# gitea

## Overview
We chose Gitea for our git server. No particular reason. I liked the name.

## Considerations

- When decrypting from sops+age, the app.ini formatting may be illegible from newlines not being interpreted. The following should reformat:

        $ sed -i '12s/\\n/\r        /g' secret.yaml
