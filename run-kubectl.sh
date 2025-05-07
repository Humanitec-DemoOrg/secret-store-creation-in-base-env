#!/bin/sh
run_cmd ()
{
    if ! "$@" 2> "$\{ERROR_FILE}"
    then
        echo
        echo "FAILED: $@"
        cat "$\{ERROR_FILE}" 1>&2
        exit 1
    fi
}
run_cmd cd $\{SCRIPTS_DIRECTORY}
if [ "$\{ACTION}" = "create" ]
then
    # TODO replacements in secret-store.yaml
    run_cmd kubectl apply -f secret-store.yaml
elif [ "$\{ACTION}" = "destroy" ]
then
  # TODO replacements in secret-store.yaml
  run_cmd kubectl delete -f secret-store.yaml
else
  echo "unrecognized ACTION: \"$\{ACTION}"\" > "$\{ERROR_FILE}"
  cat "$\{ERROR_FILE}" 1>&2
  exit 1
fi