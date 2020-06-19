
## ETCD LAB 

A distributed, reliable key-value store for the most critical data of a distributed system.  
Homepage: https://etcd.io/

Key features:

- Simple: well-defined, user-facing API (gRPC)
- Secure: automatic TLS with optional client cert authentication
- Fast: benchmarked 10,000 writes/sec
- Reliable: properly distributed using Raft


There are two major use cases: concurrency control in the distributed system and application configuration store. For example, CoreOS Container Linux uses etcd to achieve a global semaphore to avoid that all nodes in the cluster rebooting at the same time. Also, Kubernetes use etcd for their configuration store.

During this lab we will be using etcd3 python client.  
Homepage: https://pypi.org/project/etcd3/

Etcd credentials are shared on the slack channel: https://join.slack.com/t/ibm-agh-labs/shared_invite/zt-e8xfjgtd-8IDWmn912qPOflbM1yk6~Q

Please copy & paste them into the cell below:


```python
etcdCreds = {
  "connection": {
    "cli": {
      "arguments": [
        [
          "--cacert=45dc1d70-521a-11e9-8c84-3e25686eb210",
          "--endpoints=https://afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud:31190",
          "--user=ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46:230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142"
        ]
      ],
      "bin": "etcdctl",
      "certificate": {
        "certificate_base64": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURIVENDQWdXZ0F3SUJBZ0lVVmlhMWZrWElsTXhGY2lob3lncWg2Yit6N0pNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0hqRWNNQm9HQTFVRUF3d1RTVUpOSUVOc2IzVmtJRVJoZEdGaVlYTmxjekFlRncweE9ERXdNVEV4TkRRNApOVEZhRncweU9ERXdNRGd4TkRRNE5URmFNQjR4SERBYUJnTlZCQU1NRTBsQ1RTQkRiRzkxWkNCRVlYUmhZbUZ6ClpYTXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFESkYxMlNjbTJGUmpQb2N1bmYKbmNkUkFMZDhJRlpiWDhpbDM3MDZ4UEV2b3ZpMTRHNGVIRWZuT1JRY2g3VElPR212RWxITVllbUtFT3Z3K0VZUApmOXpqU1IxNFVBOXJYeHVaQmgvZDlRa2pjTkw2YmMvbUNUOXpYbmpzdC9qRzJSbHdmRU1lZnVIQWp1T3c4bkJuCllQeFpiNm1ycVN6T2FtSmpnVVp6c1RMeHRId21yWkxuOGhlZnhITlBrdGFVMUtFZzNQRkJxaWpDMG9uWFpnOGMKanpZVVVXNkpBOWZZcWJBL1YxMkFsT3AvUXhKUVVoZlB5YXozN0FEdGpJRkYybkxVMjBicWdyNWhqTjA4SjZQUwpnUk5hNXc2T1N1RGZiZ2M4V3Z3THZzbDQvM281akFVSHp2OHJMaWF6d2VPYzlTcDBKd3JHdUJuYTFPYm9mbHU5ClM5SS9BZ01CQUFHalV6QlJNQjBHQTFVZERnUVdCQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBZkJnTlYKSFNNRUdEQVdnQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwRwpDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2t4NVJzbk9PMWg0dFJxRzh3R21ub1EwOHNValpsRXQvc2tmR0pBL2RhClUveEZMMndhNjljTTdNR1VMRitoeXZYSEJScnVOTCtJM1ROSmtVUEFxMnNhakZqWEtCeVdrb0JYYnRyc2ZKckkKQWhjZnlzN29tdjJmb0pHVGxJY0FybnBCL0p1bEZITmM1YXQzVk1rSTlidEh3ZUlYNFE1QmdlVlU5cjdDdlArSgpWRjF0YWxSUVpKandyeVhsWGJvQ0c0MTU2TUtwTDIwMUwyV1dqazBydlBVWnRKcjhmTmd6M24wb0x5MFZ0Zm93Ck1yUFh4THk5TlBqOGlzT3V0ckxEMjlJWTJBMFY0UmxjSXhTMEw3c1ZPeTB6RDZwbXpNTVFNRC81aWZ1SVg2YnEKbEplZzV4akt2TytwbElLTWhPU1F5dTRUME1NeTZmY2t3TVpPK0liR3JDZHIKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
        "name": "45dc1d70-521a-11e9-8c84-3e25686eb210"
      },
      "composed": [
        "ETCDCTL_API=3 etcdctl --cacert=45dc1d70-521a-11e9-8c84-3e25686eb210 --endpoints=https://afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud:31190 --user=ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46:230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142"
      ],
      "environment": {
        "ETCDCTL_API": "3"
      },
      "type": "cli"
    },
    "grpc": {
      "authentication": {
        "method": "direct",
        "password": "230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142",
        "username": "ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46"
      },
      "certificate": {
        "certificate_base64": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURIVENDQWdXZ0F3SUJBZ0lVVmlhMWZrWElsTXhGY2lob3lncWg2Yit6N0pNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0hqRWNNQm9HQTFVRUF3d1RTVUpOSUVOc2IzVmtJRVJoZEdGaVlYTmxjekFlRncweE9ERXdNVEV4TkRRNApOVEZhRncweU9ERXdNRGd4TkRRNE5URmFNQjR4SERBYUJnTlZCQU1NRTBsQ1RTQkRiRzkxWkNCRVlYUmhZbUZ6ClpYTXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFESkYxMlNjbTJGUmpQb2N1bmYKbmNkUkFMZDhJRlpiWDhpbDM3MDZ4UEV2b3ZpMTRHNGVIRWZuT1JRY2g3VElPR212RWxITVllbUtFT3Z3K0VZUApmOXpqU1IxNFVBOXJYeHVaQmgvZDlRa2pjTkw2YmMvbUNUOXpYbmpzdC9qRzJSbHdmRU1lZnVIQWp1T3c4bkJuCllQeFpiNm1ycVN6T2FtSmpnVVp6c1RMeHRId21yWkxuOGhlZnhITlBrdGFVMUtFZzNQRkJxaWpDMG9uWFpnOGMKanpZVVVXNkpBOWZZcWJBL1YxMkFsT3AvUXhKUVVoZlB5YXozN0FEdGpJRkYybkxVMjBicWdyNWhqTjA4SjZQUwpnUk5hNXc2T1N1RGZiZ2M4V3Z3THZzbDQvM281akFVSHp2OHJMaWF6d2VPYzlTcDBKd3JHdUJuYTFPYm9mbHU5ClM5SS9BZ01CQUFHalV6QlJNQjBHQTFVZERnUVdCQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBZkJnTlYKSFNNRUdEQVdnQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwRwpDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2t4NVJzbk9PMWg0dFJxRzh3R21ub1EwOHNValpsRXQvc2tmR0pBL2RhClUveEZMMndhNjljTTdNR1VMRitoeXZYSEJScnVOTCtJM1ROSmtVUEFxMnNhakZqWEtCeVdrb0JYYnRyc2ZKckkKQWhjZnlzN29tdjJmb0pHVGxJY0FybnBCL0p1bEZITmM1YXQzVk1rSTlidEh3ZUlYNFE1QmdlVlU5cjdDdlArSgpWRjF0YWxSUVpKandyeVhsWGJvQ0c0MTU2TUtwTDIwMUwyV1dqazBydlBVWnRKcjhmTmd6M24wb0x5MFZ0Zm93Ck1yUFh4THk5TlBqOGlzT3V0ckxEMjlJWTJBMFY0UmxjSXhTMEw3c1ZPeTB6RDZwbXpNTVFNRC81aWZ1SVg2YnEKbEplZzV4akt2TytwbElLTWhPU1F5dTRUME1NeTZmY2t3TVpPK0liR3JDZHIKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
        "name": "45dc1d70-521a-11e9-8c84-3e25686eb210"
      },
      "composed": [
        "https://ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46:230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142@afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud:31190"
      ],
      "hosts": [
        {
          "hostname": "afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud",
          "port": 31190
        }
      ],
      "path": "",
      "query_options": {},
      "scheme": "https",
      "type": "uri"
    }
  },
  "instance_administration_api": {
    "deployment_id": "crn:v1:bluemix:public:databases-for-etcd:eu-de:a/a34b4e9ea7ab66770e048caf83277971:afc2bd38-f85c-4387-b5fc-f4642c7fcf7b::",
    "instance_id": "crn:v1:bluemix:public:databases-for-etcd:eu-de:a/a34b4e9ea7ab66770e048caf83277971:afc2bd38-f85c-4387-b5fc-f4642c7fcf7b::",
    "root": "https://api.eu-de.databases.cloud.ibm.com/v4/ibm"
  }
}  # copy and paste etcd credentials provided on the Slack channel here
```


```python
!pip install etcd3
```

    Requirement already satisfied: etcd3 in /opt/conda/envs/Python36/lib/python3.6/site-packages (0.12.0)
    Requirement already satisfied: protobuf>=3.6.1 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (3.6.1)
    Requirement already satisfied: grpcio>=1.27.1 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (1.29.0)
    Requirement already satisfied: tenacity>=6.1.0 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (6.2.0)
    Requirement already satisfied: six>=1.12.0 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (1.12.0)
    Requirement already satisfied: setuptools in /opt/conda/envs/Python36/lib/python3.6/site-packages (from protobuf>=3.6.1->etcd3) (40.8.0)


### How to connect to etcd using certyficate (part 1: prepare file with certificate)


```python
import base64
import tempfile

etcdHost = etcdCreds["connection"]["grpc"]["hosts"][0]["hostname"]
etcdPort = etcdCreds["connection"]["grpc"]["hosts"][0]["port"]
etcdUser = etcdCreds["connection"]["grpc"]["authentication"]["username"]
etcdPasswd = etcdCreds["connection"]["grpc"]["authentication"]["password"]
etcdCertBase64 = etcdCreds["connection"]["grpc"]["certificate"]["certificate_base64"]
                           
etcdCertDecoded = base64.b64decode(etcdCertBase64)
etcdCertPath = "{}/{}.cert".format(tempfile.gettempdir(), etcdUser)
                           
with open(etcdCertPath, 'wb') as f:
    f.write(etcdCertDecoded)

print(etcdCertPath)
```

    /home/dsxuser/.tmp/ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46.cert


### Short Lab description

During the lab we will simulate system that keeps track of logged users
- All users will be stored under parent key (path): /logged_users
- Each user will be represented by key value pair
    - key /logged_users/name_of_the_user
    - value hostname of the machine (e.g. name_of_the_user-hostname)

### How to connect to etcd using certyficate (part 2: create client)


```python
import etcd3

etcd = etcd3.client(
    host=etcdHost,
    port=etcdPort,
    user=etcdUser,
    password=etcdPasswd,
    ca_cert=etcdCertPath
)

cfgRoot='/logged_users'
```

### Task 1 : Fetch username and hostname

define two variables
- username name of the logged user (tip: use getpass library)
- hostname hostname of your mcomputer (tip: use socket library)


```python
import getpass
import socket

username = "Uladzislau"  # You can put your name here, while this code is run in the container and user name would be same for all students
hostname = socket.gethostname()

userKey='{}/{}'.format(cfgRoot, username)
userKey, '->', hostname

etcd.put(userKey, hostname)
```




    header {
      cluster_id: 17394822126184162018
      member_id: 17586574424884576738
      revision: 357085
      raft_term: 3204
    }



### Task 2 : Register number of users 

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

for all names in table fixedUsers register the appropriate key value pairs


```python
fixedUsers = [
    'Adam',
    'Borys',
    'Cezary',
    'Damian',
    'Emil',
    'Filip',
    'Gustaw',
    'Henryk',
    'Ignacy',
    'Jacek',
    'Kamil',
    'Leon',
    'Marek',
    'Norbert',
    'Oskar',
    'Patryk',
    'Rafał',
    'Stefan',
    'Tadeusz'
]

for username in fixedUsers:
    userKey='{}/{}'.format(cfgRoot, username)
    etcd.put(userKey, hostname)
```

### Task 3: List all users

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

List all registered user (tip: use common prefix)


```python
for key in etcd.get_prefix(cfgRoot):
    print(key)
```

    (b'/logged_users/Tadeusz - Registered', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-438cad81f4974877a0c254a6d6ff0145-58f95b7948-zfpxd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-75760867122b4b86a5bbcd2f5ccc321b-66fd799d96-dc62c', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'testmessage3', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'test_9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'kochana', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a7823551d9b84fd3b085958036c5f597-d469f8875-ltf7p', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adamnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Borysnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezarynotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Damiannotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emilnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Filipnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustawnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Henryknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacynotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Jaceknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamilnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Leonnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Mareknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbertnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskarnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82notebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefannotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusznotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py3690879dede28a40ed88e530f26cab9341-6cpwqdw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil godlike', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'KamilKoczera-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'KamilKoczera-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adam_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Borys_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Leon_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Norbert_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Patryk_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Stefan_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Cezary_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Emil_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Gustaw_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Ignacy_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'test', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil_atomic', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kazimierz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'notebook-condafree1py3681d3d2d480474a18b8276572c8600ae7-68hmpxx', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'condtion failed', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil-v3-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek-v3-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'value first', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'value', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-3ab835e76fd842e79b5c4a0d4084ffd0-6778f69958-x4rqx', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-b1d4673d48614999b889c4f27a801961-755d7bbffb-rb7gt', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Adam', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'user-Borys', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Emil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Leon', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Marek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Norbert', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Oskar', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Patryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'user-Stefan', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'user-Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py36ca7d2d12048646249d87c4564e316d78-78lfp26', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'normalEmil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'val3', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'value second', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Wolski-Notebook', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'true', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Adam-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Cezary-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Emil-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip-acwikla-hostname_new', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Gustaw-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Ignacy-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Kamil-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Marek-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Rafa\xc5\x82-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Tadeusz-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'temporary-acwikla-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz-super-host', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Adam-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'asdf', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'1333', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'value', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'value', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'139', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py36ca7d2d12048646249d87c4564e316d78-6f4tbxz', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Adam-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Cezary-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Emil-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Gustaw-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Ignacy-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Oskar-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Rafa\xc5\x82-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py36316d9510130e4ef2aa895ec34c3f8c96-5dpp5sp', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'DESKTOP-UIJMA2K', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Adam-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Cezary-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Emil-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Gustaw Atomic Replace', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Ignacy-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Kamil-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Marek-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Oskar-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Rafa\xc5\x82-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Tadeusz-transaction', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Albert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'konrad-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Adam-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Cezary-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'new_value', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Gustaw-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Ignacy-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Kamil-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Oskar-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Rafa\xc5\x82-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Tadeusz-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'watch', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-0b34268899e14795b60b6d36d0883ae1-576b4b5d8d-w62xc', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'value', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'value was there', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-condafree1py36df71c07b4e3b4ebe8de418e54ed7b1b8-cbcxtkz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'22', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'lock_test', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py365bb341db1c18409987fd62af4cdf6777-68sw9z2', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-438cad81f4974877a0c254a6d6ff0145-58f95b7948-zfpxd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam-hostname2', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Emil-hostname2', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Henryk-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Jacek-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py3690879dede28a40ed88e530f26cab9341-6cpwqdw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Marek-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Oskar-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Rafa\xc5\x82-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Tadeusz-hostname2', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'{callback}-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'{callback}-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'notebook-db4dad02cab04ea3be358367155cc493-5cb65bd564-dgqgr', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7d2ba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz-notebook-condafree1py362847d525672542009895af0d8d60e2f2-79xg5sk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Success', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Adam-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Borys-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Cezary-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Emil-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Filip-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Gustaw-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Henryk-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Ignacy-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Jacek-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Kamil-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Leon-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Marek-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Norbert-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Oskar-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Rafa\xc5\x82-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Stefan-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'Tadeusz-host', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz-host', <etcd3.client.KVMetadata object at 0x7f545c8daba8>)
    (b'TempUser3-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'TempUser5-hostname3', <etcd3.client.KVMetadata object at 0x7f544a7ec668>)
    (b'someValue 2', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)


### Task 4 : Same as Task2, but use transaction

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

for all names in table fixedUsers register the appropriate key value pairs, use transaction to make it a single request  
(Have you noticed any difference in execution time?)


```python
etcd.transaction(
    compare=[
        etcd.transactions.version(cfgRoot) == 0
    ],
    success=[
        etcd.transactions.put('{}/{}'.format(cfgRoot, user), '{}-hostname'.format(user)) for user in fixedUsers
    ],
    failure=[
        etcd.transactions.put('/tmp/failure', 'condtion failed')
    ]
)
```




    (False, [response_put {
        header {
          revision: 357105
        }
      }])



### Task 5 : Get single key (e.g. status of transaction)

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

Check the key you are modifying in on-failure handler in previous task


```python
for i in etcd.get_prefix('/tmp/failure'):
    print(i)
```

    (b'condtion failed', <etcd3.client.KVMetadata object at 0x7f544a7ec6d8>)


### Task 6 : Get range of Keys (Emil -> Oskar) 

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

- Get range of keys
- Is it inclusive / exclusive?
- Sort the resposne descending
- Sort the resposne descending by value not by key


```python
for key in etcd.get_range('{}/{}'.format(cfgRoot, 'Emil'), '{}/{}'.format(cfgRoot, 'Oskar'), sort_order='descend', sort_target='value'):
    print(key)
```

    (b'value first', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'testmessage3', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'test_9', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'test', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-condafree1py3690879dede28a40ed88e530f26cab9341-6cpwqdw', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'notebook-condafree1py3681d3d2d480474a18b8276572c8600ae7-68hmpxx', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'notebook-a7823551d9b84fd3b085958036c5f597-d469f8875-ltf7p', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'kochana', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'condtion failed', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'condition failed', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Tadeusznotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Tadeusz-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Tadeusz-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Tadeusz', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefannotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Stefan-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Stefan', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82notebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Rafa\xc5\x82-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Rafa\xc5\x82', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Patryknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Patryk-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Patryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskarnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Oskar-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Oskar', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Norbertnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert_transaction', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Norbert-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'Norbert-hostname', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Norbert', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Mareknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Marek-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Marek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leonnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Leon-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Leon', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kazimierz', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamilnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'KamilKoczera-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ecd68>)
    (b'KamilKoczera-hostname', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Kamil-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Kamil', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jaceknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Jacek-v3-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Jacek', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacynotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Ignacy-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Ignacy', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Henryk-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Henryk', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustawnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Gustaw-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Gustaw', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filipnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Filip-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Filip', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Emilnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Emil_atomic', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil-v3-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Emil-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Emil-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil godlike', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Emil', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Damiannotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Damian-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Damian', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezarynotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Cezary-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Cezary-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7f10b8>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Cezary', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borysnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Borys-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Borys', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adamnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam_transaction', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Adam-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adam-hostname', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7eca58>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f545c8da908>)
    (b'Adam', <etcd3.client.KVMetadata object at 0x7f544a7ec588>)


### Task 7: Atomic Replace

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

Do it a few times, check if value has been replaced depending on condition


```python
etcd.transaction(
    compare=[],
    success=[
        etcd.transactions.put('{}/{}'.format(cfgRoot, 'Uladzislau'), 'user-{}'.format('Uladzislau'))
    ],
    failure=[]
)

for _ in range(5):
    print(etcd.replace('{}/{}'.format(cfgRoot, 'Uladzislau'), 'user-{}'.format('Uladzislau'), "newUladzislau"))
```

    True
    False
    False
    False
    False


### Task 8 : Create lease - use it to create expiring key

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

You can create a key that will be for limited time
add user that will expire after a few seconds

Tip: Use lease



```python
import time

etcd.put('{}/{}'.format(cfgRoot, 'TimeLimitedUser'), 'user-{}'.format('TimeLimitedUser'), lease=etcd.lease(ttl=10))

for _ in range(10):
    time.sleep(1)
    print(etcd.get('{}/{}'.format(cfgRoot, 'TimeLimitedUser')))
```

    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f95c0>)
    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f9668>)
    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f9160>)
    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f95f8>)
    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f9128>)
    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f90f0>)
    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f9588>)
    (b'user-TimeLimitedUser', <etcd3.client.KVMetadata object at 0x7f544a7f95c0>)
    (None, None)
    (None, None)


### Task 9 : Create key that will expire after you close the connection to etcd

Tip: use threading library to refresh your lease


```python

```

### Task 10: Use lock to protect section of code

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html


```python

```

### Task 11: Watch key

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

This cell will lock this notebook on waiting  
After running it create a new notebook and try to add new user


```python

```


```python

```
