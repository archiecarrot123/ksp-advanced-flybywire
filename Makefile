KSPDIR		?= ${HOME}/.local/share/Steam/steamapps/common/Kerbal Space Program
# we quote KSPDIR because we assume it came to us unquoted
KSPDIR		:= "$(KSPDIR)"

ifeq ($(shell test -d ${KSPDIR}; echo $$?),1)
$(error KSPDIR ${KSPDIR} is empty---you should set the environment variable)
endif

MODNAME		:= AdvancedFlyByWire-Linux
FOLDERNAME	:= ksp-advanced-flybywire

MANAGED		:= ${KSPDIR}/KSP_Data/Managed
GAMEDATA	:= ${KSPDIR}/GameData
AFBWGAMEDATA	:= ${GAMEDATA}/${FOLDERNAME}
XIDIR		:= ${GAMEDATA}/${FOLDERNAME}
PLUGINDIR	:= ${AFBWGAMEDATA}/Plugins
TBCDIR		?= ${GAMEDATA}/001_ToolbarControl/Plugins
CTBDIR		?= ${GAMEDATA}/000_ClickThroughBlocker/Plugins

TARGETS		:= ${MODNAME}.dll

AFBW_FILES := \
AFBW/AxisConfiguration.cs \
AFBW/Bitset.cs \
AFBW/Configuration.cs \
AFBW/ControllerPreset.cs \
AFBW/ControllerConfigurationWindow.cs \
AFBW/DefaultControllerPresets.cs \
AFBW/EVAController.cs \
AFBW/FlightManager.cs \
AFBW/FlightProperty.cs \
AFBW/KeyboardMouseController.cs \
AFBW/ModSettingsWindow.cs \
AFBW/PresetEditorWindow.cs \
AFBW/PresetEditorWindowNG.cs \
AFBW/SDL2.cs \
AFBW/SDLController.cs \
AFBW/Stringify.cs \
AFBW/StringMarshaller.cs \
AFBW/Utility.cs \
AFBW/WarpController.cs \
AFBW/EvaluationCurves.cs \
AFBW/AdvancedFlyByWire.cs \
AFBW/IController.cs \
AFBW/CameraController.cs \
AFBW/Properties/AssemblyInfo.cs \
$e

SUPPORT_FILES := \
	License.txt \
	README.md \
	${FOLDERNAME}.version \
	Textures

RESGEN2		:= resgen2
GMCS		:= mcs
GMCSFLAGS	:= -optimize -unsafe -d:LINUX
GIT		:= git
TAR		:= tar
ZIP		:= zip

all: ${TARGETS}

info:
	@echo "${MODNAME} Build Information"
	@echo "    resgen2:    ${RESGEN2}"
	@echo "    gmcs:       ${GMCS}"
	@echo "    gmcs flags: ${GMCSFLAGS}"
	@echo "    git:        ${GIT}"
	@echo "    tar:        ${TAR}"
	@echo "    zip:        ${ZIP}"
	@echo "    KSP Data:   ${KSPDIR}"

${MODNAME}.dll: ${AFBW_FILES}
	${GMCS} ${GMCSFLAGS} -t:library -lib:${MANAGED} \
		-lib:${TBCDIR},${CTBDIR} \
		-r:Assembly-CSharp,Assembly-CSharp-firstpass \
		-r:UnityEngine,UnityEngine.UI,UnityEngine.CoreModule \
		-r:UnityEngine.PhysicsModule,UnityEngine.IMGUIModule \
		-r:UnityEngine.InputLegacyModule \
		-r:ToolbarControl,ClickThroughBlocker \
		-out:$@ $^

clean:
	rm -f ${TARGETS} AssemblyInfo.cs

install: all
	mkdir -p ${AFBWGAMEDATA}
	cp -L -r ${SUPPORT_FILES} ${AFBWGAMEDATA}/
	mkdir -p ${PLUGINDIR}
	cp ${TARGETS} ${PLUGINDIR}/

.PHONY: all clean install
