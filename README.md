## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add dashlane-audit-logs https://dashlane.github.io/dashlane-audit-logs

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
dashlane-audit-logs` to see the charts.

To install the dashlane-audit-logs chart:

    Configure the values.yaml file with your Dashlane CLI credentials and options for the audit logs job.
    - DASHLANE_CLI_RUN_DELAY : Delay in seconds between each job iteration (default at 1800 seconds - 30 minutes)
    - DASHLANE_CLI_TIMESTAMP : First timestamp used by the CLI (default at one day ago)

    helm install dashlane-audit-logs dashlane-audit-logs/dashlane-audit-logs

To uninstall the chart:

    helm delete dashlane-audit-logs