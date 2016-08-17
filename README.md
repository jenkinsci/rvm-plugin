# Jenkins RVM plugin

RVM build wrapper for Jenkins

## Update Notes

### From version 0.4 to 0.5 or above

After updating RVM plugin, you *need to update* your project's configuration files.

1. Move to your Jenkins home directory.

 ```sh
 $ cd <Jenkins home directory>
 ```

2. Get update script and save it to temporary directory.

 ```sh
 $ curl -o /tmp/convert.rb https://raw.githubusercontent.com/jenkinsci/rvm-plugin/master/bin/convert.rb
 ```

3. Update project configuration file.

 ```sh
 $ jruby /tmp/convert.rb jobs/<project>/config.xml
 ```

The update script renames original configuration file to `<original file name>.bak` in case update fails.


Contributors:
[Daniel Foglio](https://github.com/danielfoglio)
