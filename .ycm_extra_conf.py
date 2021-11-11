# import sys

def Settings( **kwargs ):

 # f = open("debug.txt", "a")
 # lang = str(kwargs['language'])
 # pname = str(kwargs['filename'])
 # cldata = str(kwargs['client_data'])
 # exe = str(sys.executable)
 # lines = [lang, pname, cldata, exe]
 # f.write(' '.join(lines))
 # f.close()

  lang = str(kwargs['language'])

  if lang == 'python':

      conda_interpreter = '/usr/local/anaconda3/bin/python'
      conda_sys_path = [
          '/home/alge',
          '/usr/local/anaconda3/lib/python37.zip',
          '/usr/local/anaconda3/lib/python3.7',
          '/usr/local/anaconda3/lib/python3.7/lib-dynload',
          '',
          '/usr/local/anaconda3/lib/python3.7/site-packages',
          '/usr/local/anaconda3/lib/python3.7/site-packages/IPython/extensions',
          '/home/alge/.ipython']

      py3_interpreter = '/home/alge/py3/bin/python'
      py3_sys_path = [
          '',
          '/home/alge/py3/lib/python37.zip',
          '/home/alge/py3/lib/python3.7',
          '/home/alge/py3/lib/python3.7/lib-dynload',
          '/usr/lib64/python3.7',
          '/usr/lib/python3.7',
          '/home/alge/py3/lib/python3.7/site-packages']


      output = {'interpreter_path': py3_interpreter,\
                'sys_path': py3_sys_path}

  if lang == 'cfamily':

      output = {'flags': ['-x', 'c++', '-Wall', '-Wextra', '-Werror']}

  return output
