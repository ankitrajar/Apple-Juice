
option=$1
passed_dir=$2
null_value=""
if [ "$passed_dir" == "$null_value" ]; then
# simulator_directory : 
lastsimulator_dir=$(cat "$1" | grep "simulator_directory" | head -1 | cut -d: -f2)
else
sed -i -e "2s/simulator_directory:.*$/simulator_directory: $passed_dir/" "$1"
lastsimulator_dir=$(cat "$1" | grep "simulator_directory" | head -1 | cut -d: -f2)
fi

this_pc_ip=$(hostname -I)

if [ "$option" == "1" ]; then
#(1) Petra Sim Build.
#cd bcmsdk-6.0/systems/sim
cd $lastsimulator_dir
#export TEJAS_PETRAB_SIM_CHANGES=1 (This command only required for sdk 6.0.1)
make all
fi

if [ "$option" == "1" ]; then
#(2) Run Petra-B Simulator
#cd bcmsdk-6.0/systems/sim
cd $lastsimulator_dir

this_pc_ip=$(hostname -I)
export SOC_TARGET_SERVER=$this_pc_ip
export SOC_TARGET_PORT=2400
export SOC_INTC_PORT=8100
export SOC_DMAC_PORT=9100
./pcid.sim bcm88375_A0
fi

if [ "$option" == "1" ]; then
#	(3) Run bcmShell
export SOC_TARGET_SERVER=$this_pc_ip
export SOC_TARGET_PORT=2400
export SOC_INTC_PORT=8100
export SOC_DMAC_PORT=9100
./bcm.sim

#	(3) Bcm Shell configuration Commands
probe
attach 0
init soc
init bcm


