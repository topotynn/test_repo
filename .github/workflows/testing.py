import json
import sys
import requests
import os

token = sys.argv[1]
header = {
    "Authorization": token,
    "Content-Type": "application/graphql"
}
url_prod = 'https://dh3onmef7bhrhkyvw7uqeoczh4.appsync-api.us-east-1.amazonaws.com/graphql'
url_dev = 'https://ry4dsee7fbgrvmkw67vybrra3i.appsync-api.us-east-1.amazonaws.com/graphql'
request_list = [
    "audience_address_list",
    # "audience_list",
    # "campaign_list",
    # "campaign_list_summary",
    # "campaign_tracking_info",
    # "campaign_tracking_info_profiles",
    # "campaign_tracking_info_summary",
    # "campaign_tracking_info_cexs",
    # "campaign_tracking_info_daily_users",
    # "campaign_tracking_info_daily_buying_power",
    # "campaign_tracking_info_months_since_creation",
    # "campaign_tracking_info_quick",
    "dashboard_info",
    # "dashboard_info_biggest_spenders",
    # "dashboard_info_bot_wallets",
    # "dashboard_info_unique_holders",
    # "dashboard_info_wash_traders",
    # "export_biggest_spenders",
    # "export_bot_wallets",
    # "export_campaign_tracking_pie_chart_slice",
    # "export_churned_users",
    # "export_reactivation",
    # "export_recovering_non_vip",
    # "export_recovering_vip",
    # "export_unique_wallets",
    # "export_wash_traders",
    # "export_whitelist",
    # "tenants_contracts",
    "whitelisting"
]


def read_request_bodies():
    with open('./request_bodies.json', 'r') as file:
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


def write_get_var(status):
    env_file = os.getenv('GITHUB_ENV')
    with open(env_file, "a") as myfile:
        myfile.write(f"ROLLBACK={status}\n")


for request in request_list:
    data = read_request_bodies()
    response = send_request(url=url_dev,
                            json_data=data[request],
                            header=header)
    write_get_var(False)
    print(request)
    if check_response(response):
        print("OK")
    else:
        print("ERROR")
        write_get_var(True)
        break
