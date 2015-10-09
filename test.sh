repo=$(basename ${PWD})
user=${${PWD%/*}##*/}

echo $repo
echo $user
