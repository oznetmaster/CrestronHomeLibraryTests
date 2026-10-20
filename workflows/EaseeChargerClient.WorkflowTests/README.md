# EaseeChargerClient processor workflow

Uses published CrestronHomeNUnit.TestAdapter 3.0.0 with a private plan selected by CRESTRON_HOME_EASEECHARGERCLIENT_WORKFLOW_SETTINGS. Discovery is offline. The CI plan runs the core desktop suites and the automatic processor unit suite, cleans its temporary instance and eligible archive, and releases the shared processor lease. Read-only live tests remain separately enabled with temporary private inputs. No charging-control test or production driver is selected.
