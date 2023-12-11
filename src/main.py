import functions_framework
import duckdb
import os
import json
import pandas as pd
import time

@functions_framework.http
def md_get_vc(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """

    # DuckDB init
    database = 'cvdb'
    conn_string = 'md:' + database + '?motherduck_token=' + os.getenv('md-svc-token')
    conn = duckdb.connect(conn_string)

    # Get input
    request_json = request.get_json(silent=True)
    request_args = request.args

    calls = request_json['calls']

    # Convert input to dataframe
    i = 0
    in_list = []
    for call in calls:
        in_list.append([i, call[0]])
        i = i + 1
    df = pd.DataFrame(in_list, columns=['row_num', 'services'])
    
    # Get vulnerability count
    entry = dict(
        severity="INFO",
        message="Dispatching query to MotherDuck."
    )
    print(json.dumps(entry))
    
    start = time.time()

    q_results = conn.execute("""
    WITH
        input_list AS (SELECT * FROM df),
        input_products AS (SELECT DISTINCT(services) FROM input_list),
        lookup_unnested_services AS (SELECT UNNEST(affectedServices) AS services FROM vulns),
        vuln_count AS (
            SELECT
                COUNT(*) AS count,
                s.services
            FROM
                lookup_unnested_services s,
                input_products i
            WHERE s.services = i.services
            GROUP BY s.services)
    SELECT v.count
    FROM input_list i, vuln_count v
    WHERE i.services = v.services
    ORDER BY row_num ASC""").fetchall()
    
    end = time.time()

    entry = dict(
    severity="INFO",
    message="MotherDuck Return: " + ', '.join(str(n[0]) for n in q_results) + "\nElapsed RTT Time: " + str(end - start) + " seconds."
    )
    print(json.dumps(entry))

    # Reconstruct into JSON and return
    return_value = []
    for row in q_results:
        return_value.append(row[0])
    return_json = json.dumps( { "replies" : return_value } )
    return return_json