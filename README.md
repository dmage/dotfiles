## Order of init scripts

### lightdm

  * `.profile`
  * `.xprofile`

### bash

  * `.bash_profile` (`-l`)
  * `.profile` (`-l`)
  * `.bashrc` (`-i` or `-l`)
  * `.shellrc` (`-i`)
  * `.shell_aliases` (`-i`)
  * `.shellrc.local` if it exists (`-i`)
  * `.bashrc.d/*` (`-i`)
