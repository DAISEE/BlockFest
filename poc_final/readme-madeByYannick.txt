
- charger un raspberry avec l'image SD clefs
(à noter qu'il faut changer la clef wifi si on n'est plus à l'école 42 dans /etc/wpa_supplicant)
- rajouter export export PATH=$PATH:$HOME/go-ethereum/build/bin pour avoir geth dans le path

Sur le raspberry, on lance geth comme cela
 > geth --rpc --rpcaddr 10.19.244.249 --rpccorsdomain="*" --networkid "1234" --identity "Node1" --datadir "~/data4" --verbosity 4 --maxpeers 5  --ipcpath /home/pi/data4/geth.ipc

 Changez
  - mettre l'@IP du noeud adresse IP
  - utiliser un --identity unique pour chaque noeud
  - que le data4/nodekey soit unique entre les nodes (changez juste 1 caractères dans le fichier)

Dans data4, il y a 5 comptes : xavier, benoit, mineur, lds  + paul

A noter : on doit souvent débloquer les comptes :
personal.unlockAccount("0x07d3ead725b9dcc43a65393a8491348f315b9ef8", "xavier")
personal.unlockAccount("0xfd74c00b02177b5a73512ebcbd7ebdcace10dcc8", "benoit")
personal.unlockAccount("0x64ed936be8e205d999021cf80a8141b54eb9adc6", "mineur")
personal.unlockAccount("0x944de8f9211a3870e3579d14931c9e8d90b08349", "lds")
personal.unlockAccount("0x6f5311661020aa90d16cc7b03e2f1ebf75764db4", "paul")

Les 3 nodes pendant le blockfest, rajoutés tels quels :
[
 "enode://84a01b8c3dfcb0f22b861219ed7dcc05152b54e02107f78f8662ecbaa6fe550231392360efea597d302ccee630f4194d6b19079e2ef5e032e9a61dac7f912fae@[10.19.244.249]:30303",
 "enode://ff2132b6ecb0c9c22e7d429714d53006c50504099e109bd81f9843d984fe1a2cc01afb0dfed3558b267e732238e7ad98fed0d73f73235f0c51a3e1a00f638674@[10.19.244.247]:30303",
 "enode://d490c368b193b90ec7019019b46eb15e8e5ed9240a1f48041848c75e19951e1d47478355e8912ca9e7e64ca0674e61590f3d7dc9565426b0fd545148814d9f83@[10.19.244.240]:30303",
 "enode://84a01b8c3dfcb0f22b861219ed7dcc05152b54e02107f78f8662ecbaa6fe550231392360efea597d302ccee630f4194d6b19079e2ef5e032e9a61dac7f912fae@[10.19.245.188]:30303"
]
