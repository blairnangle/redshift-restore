# redshift-restore

Accompanies the blog post
at [blairnangle.com/blog/restoring-a-production-redshift-cluster-in-another-environment-from-snapshot](https://blairnangle.com/blog/restoring-a-production-redshift-cluster-in-another-environment-from-snapshot).

## Usage (creating and sharing snapshot)

### Install requirements

```shell
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Standard auth

`snapshot.py` uses a regular AWS Access Key ID and Secret Access Key:

```shell
export SOURCE_ACCOUNT_AWS_ACCESS_KEY_ID=…
export SOURCE_ACCOUNT_AWS_SECRET_ACCESS_KEY=…

export TARGET_ACCOUNT_AWS_ACCOUNT_NUMBER=…
```

```shell
./snapshot.py
```

### Session-based auth

`snapshot-with-sesson.py` uses the credentials above plus an accompanying Session Token.

As above, _plus_:

```shell
export SOURCE_ACCOUNT_AWS_SESSION_TOKEN=…
```

```shell
./snapshot-with-session.py
```

## Costs

The usual disclaimer about AWS resources costing actual money applies.

## License

Distributed under an [MIT License](./LICENSE).
