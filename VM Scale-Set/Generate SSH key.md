# Generating SSH Key

__Remove Existing SSH Public/Private Key__
```bash
    rm ~/.ssh/id_rsa*
```

__Recreate the keypair, choosing a new passphrase:__
```bash
    ssh-keygen -t rsa -f ~/.ssh/id_rsa
```

__Add the newly created private key to your OS X Keychain to store the passphrase and manage unlocking it automaticall__
```bash
    ssh-add -K ~/.ssh/id_rsa
```

__Copy the public key to the OS X clipboard for adding to web services like GitHub, etc.__
```bash
    cat ~/.ssh/id_rsa.pub | pbcopy
```

