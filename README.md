# command-tools
Shortcut command tools to execute own small functions


# Functions

## Powershell setup (once)

* install latest [Powershell](https://github.com/PowerShell/PowerShell)
* run `code $profile`, in a command window, and replace the content with a single line (starting with a dot, replace tools if differnt path used): 
  ` . <path to this folder>functions.ps1`
* save profile file
* validate, in a new command/powershell window: `np`, should open the profile file, and the function file 




## Steps to Set Up the .sh File in Mac OSx:
- Save the File: Save your script file, for example, as shortcuts.sh.

- Make It Executable: Run the following command to make your script executable:

  ```
  chmod +x shortcuts.sh
  ```


- Source the File: To use the shortcuts in your terminal, you need to source the script in your shell configuration file (e.g., .zshrc or .bash_profile):

  - Open the file:
  ```
  nano ~/.zshrc
  ```

  - Add the following line:
  ```
  source /path/to/shortcuts.sh
  ```

  - Replace /path/to/ with the full path to your script.

- Reload the Shell: After editing .zshrc or .bash_profile, reload it:

  ```
  source ~/.zshrc
  ```