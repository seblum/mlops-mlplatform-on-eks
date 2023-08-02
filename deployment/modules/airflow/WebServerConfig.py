#######################################
# Custom AirflowSecurityManager
#######################################
from airflow.www.security import AirflowSecurityManager
import os


class CustomSecurityManager(AirflowSecurityManager):
    def get_oauth_user_info(self, provider, resp):
        if provider == "github":
            user_data = self.appbuilder.sm.oauth_remotes[provider].get("user").json()
            emails_data = (
                self.appbuilder.sm.oauth_remotes[provider].get("user/emails").json()
            )
            teams_data = (
                self.appbuilder.sm.oauth_remotes[provider].get("user/teams").json()
            )

            # unpack the user's name
            first_name = ""
            last_name = ""
            name = user_data.get("name", "").split(maxsplit=1)
            if len(name) == 1:
                first_name = name[0]
            elif len(name) == 2:
                first_name = name[0]
                last_name = name[1]

            # unpack the user's email
            email = ""
            for email_data in emails_data:
                if email_data["primary"]:
                    email = email_data["email"]
                    break

            # unpack the user's teams as role_keys
            # NOTE: each role key will be "my-github-org/my-team-name"
            role_keys = []
            for team_data in teams_data:
                team_org = team_data["organization"]["login"]
                team_slug = team_data["slug"]
                team_ref = team_org + "/" + team_slug
                role_keys.append(team_ref)

            return {
                "username": "github_" + user_data.get("login", ""),
                "first_name": first_name,
                "last_name": last_name,
                "email": email,
                "role_keys": role_keys,
            }
        else:
            return {}


#######################################
# Actual `webserver_config.py`
#######################################
from flask_appbuilder.security.manager import AUTH_OAUTH

# only needed for airflow 1.10
# from airflow import configuration as conf
# SQLALCHEMY_DATABASE_URI = conf.get("core", "SQL_ALCHEMY_CONN")

AUTH_TYPE = AUTH_OAUTH
SECURITY_MANAGER_CLASS = CustomSecurityManager

# registration configs
AUTH_USER_REGISTRATION = True  # allow users who are not already in the FAB DB
AUTH_USER_REGISTRATION_ROLE = (
    "Public"  # this role will be given in addition to any AUTH_ROLES_MAPPING
)

# the list of providers which the user can choose from
OAUTH_PROVIDERS = [
    {
        "name": "github",
        "icon": "fa-github",
        "token_key": "access_token",
        "remote_app": {
            "client_id": os.getenv("GITHUB_CLIENT_ID"),
            "client_secret": os.getenv("GITHUB_CLIENT_SECRET"),
            "api_base_url": "https://api.github.com",
            "client_kwargs": {"scope": "read:org read:user user:email"},
            "access_token_url": "https://github.com/login/oauth/access_token",
            "authorize_url": "https://github.com/login/oauth/authorize",
        },
    },
]

# a mapping from the values of `userinfo["role_keys"]` to a list of FAB roles
AUTH_ROLES_MAPPING = {
    "mlplatform-seblum-me/airflow-users-team": ["User"],
    "mlplatform-seblum-me/airflow-admin-team": ["Admin"],
}

# if we should replace ALL the user's roles each login, or only on registration
AUTH_ROLES_SYNC_AT_LOGIN = True

# force users to re-auth after 30min of inactivity (to keep roles in sync)
PERMANENT_SESSION_LIFETIME = 1800
