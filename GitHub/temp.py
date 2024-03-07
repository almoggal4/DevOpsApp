import requests

# Jenkins API credentials and base URL
USERNAME = 'root'
PASSWORD = 'Lihialm1!'
JENKINS_URL = 'http://localhost:8080'

# # API endpoint for system configuration
# SYSTEM_CONFIG_URL = f"{JENKINS_URL}/systemConfig/"
#
# # XML configuration for system settings (example)
# system_config_xml = """
# <jenkins>
#     <numExecutors>2</numExecutors>
#     <!-- Other system configuration settings go here -->
# </jenkins>
# """
#
# # Update system configuration
#
# headers = {'Content-Type': 'application/xml'}
# response = requests.post(SYSTEM_CONFIG_URL,
#                          auth=(USERNAME, PASSWORD),
#                          headers=headers,
#                          data=system_config_xml)
#
# if response.status_code == 200:
#     print("System configuration updated successfully.")
# else:
#     print(f"Failed to update system configuration. Status code: {response.status_code}")
SYSTEM_CONFIG_URL = f"{JENKINS_URL}/systemConfig.xml"
response = requests.get(SYSTEM_CONFIG_URL, auth=(USERNAME, PASSWORD))
print(response.text)
