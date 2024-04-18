#!/usr/bin/env python

import os
import sys
import boto3
import time

source_session: boto3.Session = boto3.Session(
    aws_access_key_id=os.getenv("SOURCE_ACCOUNT_AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.getenv("SOURCE_ACCOUNT_AWS_SECRET_ACCESS_KEY"),
    aws_session_token=os.getenv("SOURCE_ACCOUNT_AWS_SESSION_TOKEN"),
    region_name="eu-west-1",
)

source_client = source_session.client("redshift")

snapshot_identifier = f"test-environment-snapshot-{int(time.time())}"
cluster_identifier = "my-cluster"
target_aws_account_number = os.getenv("TARGET_ACCOUNT_AWS_ACCOUNT_NUMBER")

create_response = source_client.create_cluster_snapshot(
    SnapshotIdentifier=snapshot_identifier,
    ClusterIdentifier=cluster_identifier,
    ManualSnapshotRetentionPeriod=8,
)

if create_response["ResponseMetadata"]["HTTPStatusCode"] != 200:
    sys.exit(1)

start_time = time.time()
snapshot_available = False
while not snapshot_available:
    describe_response = source_client.describe_cluster_snapshots(
        SnapshotIdentifier=snapshot_identifier,
    )
    if describe_response["Snapshots"][0]["Status"] == "available":
        snapshot_available = True
    else:
        time.sleep(60.0 - ((time.time() - start_time) % 60.0))

authorize_response = source_client.authorize_snapshot_access(
    SnapshotIdentifier=snapshot_identifier,
    AccountWithRestoreAccess=target_aws_account_number,
)

if authorize_response["ResponseMetadata"]["HTTPStatusCode"] == 200:
    print(snapshot_identifier)
    sys.exit(0)
else:
    sys.exit(1)
