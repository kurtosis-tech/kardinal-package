postgres = import_module("github.com/kurtosis-tech/postgres-package/main.star")

def run(plan, ecr_username="", ecr_password=""):
    db = postgres.run(plan, database="kardinal")

    # run kontrol service
    plan.add_service(
        name="kontrol-service",
        config=ServiceConfig(
            # use nix build spec?
            image = ImageSpec(
                image = "258623609258.dkr.ecr.us-east-1.amazonaws.com/kurtosistech/kontrol-service:latest",
                username = ecr_username,
                password = ecr_password,
                registry = "258623609258.dkr.ecr.us-east-1.amazonaws.com"
            ),
            ports={
                "api": PortSpec(
                    number=8080, 
                    transport_protocol="TCP",
                    application_protocol="HTTP",
                ),
            },
            public_ports={
                "api": PortSpec(
                    number=8080, 
                    transport_protocol="TCP",
                    application_protocol="HTTP",
                ),
            },
            env_vars={
                "DB_NAME": "kardinal",
                "DB_HOSTNAME": db.service.hostname,
                "DB_USER": db.user,
                "DB_PASSWORD": db.password,
                "DB_PORT": db.port,
            }
        )
    )