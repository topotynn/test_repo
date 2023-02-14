import json
import sys
import requests
import os
import time


def read_request_bodies():
    with open('./testing/request_bodies.json', 'r') as file:
        file = file.read()
        data = json.loads(file)
    return data


def to_string(json_data):
    result_string = ''
    for line in json_data:
        result_string += line + '\n'
    return result_string


def send_request(url, json_data, header):
    result_string = to_string(json_data)
    response = requests.post(url=url,
                             json={"query": result_string},
                             headers=header,
                             timeout=30)
    return response


def check_response(response):
    json_response = json.loads(response.text)
    result = True
    if response.status_code != 200:
        result = False
        return result
    if 'errors' in json_response:
        result = False
        print(json_response.setdefault('errors', "this is default answer..."))
    return result


def write_get_var(text):
    env_file = os.getenv('GITHUB_ENV')
    with open(env_file, "a") as myfile:
        myfile.write(f"ERROR_MESSAGE={text}\n")


# Create a function to test each request
def test_requests():
    token = os.environ['ACCEESS_TOKEN']
    appsync_url = os.environ['URI']
    request_bodies = read_request_bodies()

    header = {
        "Authorization": token,
        "Content-Type": "application/graphql"
    }
    for request, body in request_bodies.items():
        # Send the request
        # print(f"Request Headers: {header}")

        start_time = time.time()
        response = send_request(url=appsync_url,
                                json_data=body,
                                header=header)
        end_time = time.time()

        print(request)
        print(f"Request Body: {json.dumps({'query': body})}")
        print(response.status_code)

        # Test the response time
        response_time = end_time - start_time
        # assert that the response time is less than a certain threshold
        assert response_time < 25, f"TEST {request} failed with timeout. Please check with the Big Boss."
        # check status code
        assert response.status_code == 200, f"TEST {request} failed with code status {response.status_code}. Please check with the Big Boss."
        # Test the status
        json_response = response.json()
        assert 'errors' not in json_response, f"TEST {request} failed with error: {json_response['errors']}. Please check with the Big Boss."
        response.close()


try:
    test_requests()
except Exception as e:
    write_get_var(e)
    sys.exit('1')
