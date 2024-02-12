"""
### Run a dbt Core project as a task group with Cosmos

Simple DAG showing how to run a dbt project as a task group, using
an Airflow connection and injecting a variable into the dbt project.
"""

from airflow.decorators import dag, task
from airflow.operators.python import BranchPythonOperator
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, RenderConfig
from cosmos.constants import TestBehavior
from airflow.utils.trigger_rule import TriggerRule


from pendulum import datetime
import os

DBT_PROJECT_PATH = f"{os.environ['AIRFLOW_HOME']}/datahub_dbt"

profile_config = ProfileConfig( 
    profile_name="datahub_dbt", 
    target_name="dev",
    profiles_yml_filepath="/opt/airflow/datahub_dbt/profiles/profiles.yml",
) 

render_config = RenderConfig(
    select=["tag:Daily_Main"],
    test_behavior=TestBehavior.AFTER_ALL,
)

@dag(
    start_date=datetime(2023, 8, 1),
    schedule=None,
    catchup=False,
    params={"my_name": "dwlee", 'basedate2': '2024-02-02'},
)
def my_simple_dbt_dag():
    transform_data = DbtTaskGroup(
        group_id="transform_data",
        project_config=ProjectConfig(DBT_PROJECT_PATH),
        profile_config=profile_config,
        operator_args={
            "vars": {"basedate": "{{ params.basedate2 }}"},
        },
        render_config=render_config,
    )
    
    @task(task_id="success", trigger_rule="all_success")
    def print_sucess():
        print(f"Sucess")

    @task(task_id="fail", trigger_rule="one_failed")
    def print_fail():
        print(f"Fail")

    transform_data >> [print_sucess(), print_fail()]
    # transform_data 


my_simple_dbt_dag()