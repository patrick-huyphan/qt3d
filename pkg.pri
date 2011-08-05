# Config for making example and demo apps packageable

# Note that the paths here all assumed the including .pro file
# is exactly 3 levels of directory tree below the root

qtc_harmattan {
    CONFIG += maemo
    CONFIG += package
    QMAKE_CXXFLAGS += -Wno-psabi
    # The Qt SDK / Qt Creator harmattan integration needs some special treatment
    QT3D_INSTALL_BINS = /bin
    QT3D_INSTALL_LIBS = /usr/lib
    QT3D_INSTALL_PLUGINS = /usr/lib/qt4/plugins
    QT3D_INSTALL_IMPORTS = /usr/lib/qt4/imports
    QT3D_INSTALL_DATA = /usr/share/qt4
} else {
    QT3D_INSTALL_BINS = $$[QT_INSTALL_BINS]
    QT3D_INSTALL_LIBS = $$[QT_INSTALL_LIBS]
    QT3D_INSTALL_PLUGINS = $$[QT_INSTALL_PLUGINS]
    QT3D_INSTALL_IMPORTS = $$[QT_INSTALL_IMPORTS]
    QT3D_INSTALL_DATA = $$[QT_INSTALL_DATA]
}

qt3dquick_deploy_pkg {
    CONFIG += qt3d_deploy_pkg

    package {
        macx:CONFIG(qt_framework, qt_framework|qt_no_framework) {
            LIBS += -framework Qt3DQuick -F../../../src/quick3d
            INCLUDEPATH += ../../../src/quick3d/Qt3DQuick.framework/Versions/1/Headers
        } else {
            win32 {
                CONFIG(debug, debug|release) {
                    TARGET = $$member(TARGET, 0)d
                    LIBS += ..\\..\\..\\src\\quick3d\\debug\\Qt3DQuickd.lib
                } else {
                    LIBS += ..\\..\\..\\src\\quick3d\\release\\Qt3DQuick.lib
                }
            } else {
                LIBS += -L../../../src/quick3d -lQt3DQuick
            }
            INCLUDEPATH += ../../../include/Qt3DQuick
        }
        QT += declarative opengl

        maemo: icons.files = icon-l-qtquick3d.png
    } else {
        CONFIG += qt3dquick
    }
}

qt3d_deploy_pkg {
    package {
        macx:CONFIG(qt_framework, qt_framework|qt_no_framework) {
            LIBS += -framework Qt3D -F../../../src/threed
            INCLUDEPATH += ../../../src/threed/Qt3D.framework/Versions/1/Headers
        } else {
            win32 {
                CONFIG(debug, debug|release) {
                    TARGET = $$member(TARGET, 0)d
                    LIBS += ..\\..\\..\\src\\threed\\debug\\Qt3Dd.lib
                } else {
                    LIBS += ..\\..\\..\\src\\threed\\release\\Qt3D.lib
                }
            } else {
                LIBS += -L../../../src/threed -lQt3D
            }
            INCLUDEPATH += ../../../include/Qt3D
        }
        QT += opengl

        !qt3dquick_deploy_pkg: maemo: icons.files = icon-l-qt3d.png
    } else {
        CONFIG += qt3d
    }
}

contains(TEMPLATE, app) {
    package  {
        maemo {
            applnk.files = $${TARGET}.desktop
            applnk.path = /usr/share/applications

            # icons.files is set by qt3dquick_pkg_dep.pri or qt3d_pkg_dep.pri
            icons.path = /usr/share/themes/base/meegotouch/icons
            INSTALLS += icons applnk

            target.path += $$QT3D_INSTALL_BINS
            INSTALLS += target
        } else {
            mt {
                applnk.files = info.json
                applnk.path = /opt/mt/applications/$${TARGET}

                # icons.files is set by qt3dquick_pkg_dep.pri or qt3d_pkg_dep.pri
                icons.path = /opt/mt/applications/$${TARGET}
                INSTALLS += icons applnk
                target.path += /opt/mt/applications/$${TARGET}
                INSTALLS += target

                DEFINES += QT3D_USE_OPT=$${TARGET}
            } else {
                target.path += $$QT3D_INSTALL_BINS
                INSTALLS += target
            }
        }
    } else {
        DESTDIR = ../../../bin
    }
}

qt3d_deploy_qml {
    mt {
        TARGET_DIR = /opt/mt/applications/$$TARGET
    } else {
        TARGET_DIR = $$QT3D_INSTALL_DATA/quick3d/resources/examples/$$TARGET
    }
    symbian {
        TARGET_DIR = .
    } else: macx {
        TARGET_DIR = .
    } else {
        !package {
            TARGET_DIR = ../../../bin/resources/examples/$$TARGET
        }
    }
    for(dir, INSTALL_DIRS) {
        di.source = $${dir}
        di.target = $$TARGET_DIR
        DEPLOYMENTFOLDERS += di
    }
}

# The following code was generated by the Qt Quick Application wizard of Qt Creator.
# The file it was contained in was qmlapplicationviewer.pri, if necessary it should
# be possible to simply cut & paste the code straight out of the latest version to
# update it.
#
# The only changes has been to comment out the installPrexfix line below, this
# will probably be necessary to replicate when replacing.
#
defineTest(qtcAddDeployment) {
    MAINPROFILEPWD = $$PWD

    win32 {
        copyCommand =
        !package {
            for(deploymentfolder, DEPLOYMENTFOLDERS) {
                source = $$MAINPROFILEPWD/$$eval($${deploymentfolder}.source)
                source = $$replace(source, /, \\)
                sourcePathSegments = $$split(source, \\)
                target = $$OUT_PWD/$$eval($${deploymentfolder}.target)/$$last(sourcePathSegments)
                target = $$replace(target, /, \\)
                !isEqual(source,$$target) {
                    !isEmpty(copyCommand):copyCommand += &&
                    isEqual(QMAKE_DIR_SEP, \\) {
                        copyCommand += $$QMAKE_COPY_DIR \"$$source\" \"$$target\"
                    } else {
                        source = $$replace(source, \\\\, /)
                        target = $$OUT_PWD/$$eval($${deploymentfolder}.target)
                        target = $$replace(target, \\\\, /)
                        copyCommand += test -d \"$$target\" || mkdir -p \"$$target\" && cp -r \"$$source\" \"$$target\"
                    }
                }
            }
            !isEmpty(copyCommand) {
                message(copyCommand - $$copyCommand)
                copyCommand = @echo Copying application data... && $$copyCommand
                copydeploymentfolders.commands = $$copyCommand
                first.depends = $(first) copydeploymentfolders
                export(first.depends)
                export(copydeploymentfolders.commands)
                QMAKE_EXTRA_TARGETS += first copydeploymentfolders
            }
        }
        for(deploymentfolder, DEPLOYMENTFOLDERS) {
            item = item$${deploymentfolder}
            itemfiles = $${item}.files
            $$itemfiles = $$eval($${deploymentfolder}.source)
            itempath = $${item}.path
            $$itempath = $$eval($${deploymentfolder}.target)
            export($$itemfiles)
            export($$itempath)
            INSTALLS += $$item
        }
    } else:unix {
        maemo5 {
            desktopfile.files = $${TARGET}.desktop
            desktopfile.path = /usr/share/applications/hildon
            icon.files = $${TARGET}64.png
            icon.path = /usr/share/icons/hicolor/64x64/apps
        } else {
            desktopfile.files = $${TARGET}_harmattan.desktop
            desktopfile.path = /usr/share/applications
            icon.files = $${TARGET}80.png
            icon.path = /usr/share/icons/hicolor/80x80/apps
            copyCommand =
            for(deploymentfolder, DEPLOYMENTFOLDERS) {
                source = $$MAINPROFILEPWD/$$eval($${deploymentfolder}.source)
                source = $$replace(source, \\\\, /)
                macx {
                    target = $$DESTDIR/$${TARGET}.app/Contents/Resources/$$eval($${deploymentfolder}.target)
                } else {
                    target = $$DESTDIR/$$eval($${deploymentfolder}.target)
                }
                target = $$replace(target, \\\\, /)
                sourcePathSegments = $$split(source, /)
                targetFullPath = $$target/$$last(sourcePathSegments)
                !isEqual(source,$$targetFullPath) {
                    !isEmpty(copyCommand):copyCommand += &&
                    copyCommand += $(MKDIR) \"$$target\"
                    copyCommand += && $(COPY_DIR) \"$$source\" \"$$target\"
                }
            }
            !isEmpty(copyCommand) {
                copyCommand = @echo Copying application data... && $$copyCommand
                copydeploymentfolders.commands = $$copyCommand
                first.depends = $(first) copydeploymentfolders
                export(first.depends)
                export(copydeploymentfolders.commands)
                QMAKE_EXTRA_TARGETS += first copydeploymentfolders
            }
        }
#        installPrefix = /opt/$${TARGET}
        for(deploymentfolder, DEPLOYMENTFOLDERS) {
            item = item$${deploymentfolder}
            itemfiles = $${item}.files
            $$itemfiles = $$eval($${deploymentfolder}.source)
            itempath = $${item}.path
            $$itempath = $${installPrefix}/$$eval($${deploymentfolder}.target)
            export($$itemfiles)
            export($$itempath)
            INSTALLS += $$item
        }
        target.path = $${installPrefix}/bin
        export(icon.files)
        export(icon.path)
        export(desktopfile.files)
        export(desktopfile.path)
        export(target.path)
        INSTALLS += desktopfile icon target
    }

    export (ICON)
    export (INSTALLS)
    export (LIBS)
    export (QMAKE_EXTRA_TARGETS)
}
