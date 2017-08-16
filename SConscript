import os
import sys

Import('root')

#print "Rtech1 sys path", Dir('.').rel_path(Dir("#%s" % root))
#print Dir('.').abspath
#print Dir(Dir('.').rel_path(Dir("#r-tech1"))).abspath
sys.path.append(Dir('.').rel_path(Dir("#%s" % root)))

import scons_rtech1.utils
import scons_rtech1.checks

Import('env')
Import('build_dir_root')

build_type = 'release'
if scons_rtech1.utils.useAndroid():
    build_type = 'armeabi-v7a'
if scons_rtech1.utils.useAndroidX64():
    build_type = 'android-x64'
    
config = env.Configure(custom_tests = {'CheckAllegro5': scons_rtech1.checks.checkAllegro5(scons_rtech1.checks.debug()),
                                       'CheckFreetype': scons_rtech1.checks.checkFreetype,
                                       'ConfigChecks': scons_rtech1.checks.configChecks})

if scons_rtech1.utils.useAndroidX64():
    env['HAVE_ALLEGRO5'] = True
    env.Append(CPPDEFINES = ['USE_ALLEGRO5'])
else:
    config.CheckAllegro5()
    config.CheckFreetype()

config.ConfigChecks()
env = config.Finish()

if not env['HAVE_ALLEGRO5']:
    Exit(1)

if scons_rtech1.checks.debug():
    env.Append(CXXFLAGS = ['-g3','-ggdb', '-Werror'])

build_dir = '%s/%s' % (build_dir_root, build_type if not scons_rtech1.checks.debug() else 'debug')
options = {'networking': False,
           'allegro5': True
          }

def getLibName():
    if scons_rtech1.utils.useAndroid():
        return 'lib/r-tech1-arm'
    if scons_rtech1.checks.debug():
        return 'lib/r-tech1-debug'
    return 'lib/r-tech1'

libname = getLibName()

env.Append(CPPPATH = [Dir('include', Dir('.').rel_path(Dir('#' + root)))])

env.VariantDir(build_dir, 'src')
libs = env.SConscript('src/SConscript', variant_dir=build_dir, exports=['env', 'options', 'root'])
rtech1 = env.StaticLibrary(libname, libs)
Alias('rtech1', rtech1)

tests_build_dir = os.path.join(build_dir, 'tests')
unit_tests = []
if not scons_rtech1.utils.useAndroid() and False:
    unit_tests = SConscript('tests/SConscript', variant_dir = tests_build_dir, exports = ['env', 'rtech1', 'root'], duplicate=0)
env.Depends(unit_tests, rtech1)

if os.access(env.installPrefix, os.W_OK):
    installEnv = env.Clone(tools = ['textfile'])
    # Install target and configuration
    installEnv.Install('{0}/lib'.format(installEnv.installPrefix), rtech1)

    header_prefix = '{0}/include/r-tech1'.format(installEnv.installPrefix)

    include_dir = 'include/r-tech1'
    for root, dirs, files in os.walk(include_dir):
        for file in files:
            # print "Install %s, %s" % (header_prefix + root[len('include/r-tech1'):], os.path.join(root, file))
            # Install to <header location>/<local subdirectory>. The root contains the full
            # include/r-tech1/subdirectory, so we chop off the leading include/r-tech1
            installEnv.Install(header_prefix + root[len(include_dir):], os.path.join(root, file))

    installEnv.Install(os.path.join(header_prefix, 'lz4'), 'src/libs/lz4/lz4.h')

    # pkg-config file create
    pc_mod, pc_install = scons_rtech1.utils.pc_install(installEnv, build_dir, scons_rtech1.checks.debug()) 

    # Install pkg-config file
    installEnv.Alias('install', [installEnv.installPrefix, pc_install])
    installEnv.Depends([installEnv.installPrefix, pc_mod], rtech1)

    # Uninstall target
    installEnv.Command("uninstall", None, Delete(FindInstalledFiles()))
else:
    def needsudo(target, source, env):
        print 'No write priveleges to {0}, run target [{1}] as sudo'.format(env.installPrefix, target[0])
    env.Command('install', None, needsudo)
    env.Depends('install', ['rtech1', 'tests'])
    env.Command('uninstall', None, needsudo)
    env.Depends('uninstall', ['rtech1', 'tests'])

#env.Install('headers', Dir('include', Dir('.').rel_path(Dir("#%s" % root))).abspath)
#env.Install('headers/include/lz4', File('src/libs/lz4/lz4.h', Dir('.').rel_path(Dir('#%s' % root))).abspath)

#env.Install(os.path.join(build_dir, 'headers'), Dir('include', Dir('.').rel_path(Dir("#%s" % root))).abspath)
#env['RTECH1_HEADERS'] = Dir('headers', Dir(build_dir))

include_dir = 'include/r-tech1'
root_dir = Dir('include/r-tech1', Dir('#%s' % root)).abspath
for myroot, dirs, files in os.walk(root_dir):
    for file in files:
        source = os.path.join(myroot, file)
        dir = myroot[len(root_dir) + 1:]
        # print "Stripped %s" % os.path.join(source[len(root_dir) + 1:])
        # print Dir('headers/r-tech1', Dir(build_dir)).abspath
        destination = Dir(dir, Dir('headers/r-tech1', Dir(build_dir))).abspath
        # print "Install %s -> %s" % (source, destination)
        # Install to <header location>/<local subdirectory>. The root contains the full
        # include/r-tech1/subdirectory, so we chop off the leading include/r-tech1
        # env.Install(os.path.join(build_dir, 'headers/r-tech1', root[len(include_dir):]), File(os.path.join(root, file), Dir('.').rel_path(Dir('#%s' % root))).abspath)
        # env.Install(destination, File(source, Dir('.').rel_path('#%s' % root)).abspath)
        # env.Install(destination, File(source))

# env.Install(os.path.join(build_dir, 'headers/r-tech1/lz4'), File('src/libs/lz4/lz4.h', Dir('.').rel_path(Dir('#%s' % root))).abspath)

# env['RTECH1_HEADERS'] = [Dir('include', Dir('.').rel_path(Dir('#%s' % root))).abspath, Dir('headers', Dir(build_dir))]
env['RTECH1_HEADERS'] = [Dir('include', Dir('.').rel_path(Dir('#%s' % root))).abspath]
# env['RTECH1_HEADERS'] = [Dir('headers', Dir(build_dir))]

# env.Default(rtech1)
env.Alias('tests', unit_tests)

for test in unit_tests:
    orig = str(test).translate(None,'[]\'')
    to = orig.replace('{0}/tests/'.format(build_dir), '')
    #print orig, to
    copy = Command('bin/{0}'.format(to), orig, Copy('$TARGET', '$SOURCE'))
    env.Depends(copy, test)
    env.Alias('tests', copy)

Return('rtech1')