########################################
#
# Author:       Heidi Koldsoe
# Date:         20.07.12
# Description:  Exchange of POPC bilayer into a membrane with specific upper and lower leaflet composition
#
#
#########################################

#########################################################
#                                                       #
#       If to few arguments print usage                 #
#                                                       #
#########################################################
puts "Number of arguments $argc"

proc membrane_usage { } {

   puts "                       "
   puts "                       "
   puts " USAGE:   vmd -dispdev text -e exchange_lipids.tcl -args <grofile> -f <grofile> -ut <upper-type> -uc <upper-composition> -lt <lower-type> -lc <lower-composition>"
   puts "<grofile> is the input grofile"
   puts ""
   puts "<upper-type> is the lipid types within the upper leaflet. Should start with POPC. E.g. POPC:POPE:DHPC"
   puts "<upper-composition> is the composition (in percantage) of the upper leaflet lipids. E.g. 80:10:10"
   puts "<lower-type> is the lipid types within the lower leaflet. Should start with POPC. E.g. POPC:POPS:PPCS:DHPC"
   puts "<lower-composition> is the composition (in percentage) of the lower leaflet lipids. E.g. 50:20:10:20"
   puts "                                       "
   puts ""
   puts "LIPIDS currently available: DPPC, DHPC, DLPC, POPC, DUPC, DPSM, DPPE, DHPE, DLPE, POPE, POPG, POPS, GM3, PIP2, PIP3, CHO......"
   puts "More LIPIDS available: DPPI PSPI"
   puts "               "
   puts " EXAMPLE: vmd -dispdev text -e exchange_lipids.tcl -args -f system.gro -ut POPC:POPE:DPPC -uc 80:10:10 -lt POPC:POPS:POPG:PPCS -lc 50:10:20:20"
   puts "                       "
   puts "" 
   puts " DESCRIPTION: This script will transform a POPC (with cholesterol) to a membrane with the specified composition of the upper and lower leaflet "
   puts ""
   puts ""
   exit

}
#########################################################
#                                                       #
#       Set the input values                            #
#                                                       #
#########################################################
if { $argc  < 6} { membrane_usage }


	# check if #arguments is a) even, b) >= 6 and <= 8
	for {set i 0} {$i < [expr $argc - 1]} {incr i 1} {
	lappend args [lindex $argv $i]
	}
	set n [llength $args]
	 if { [expr fmod($n,2)] } { membrane_usage }
         if { $n > 6 && $n < 10 } { membrane_usage }


	# get all options
    for { set i 0 } { $i < $n } { incr i 2 } {
        set key [lindex $args $i]
        set val [lindex $args [expr $i + 1]]
        set cmdline($key) $val 
    }


 

	    # set parameters
	    set grofile $cmdline(-f)
	 if { [info exists cmdline(-ut)] } {
	set up_liplist [string toupper $cmdline(-ut)]
            set up_percentagelist $cmdline(-uc)
	regsub -all {:} $up_liplist " " up_liplist
	regsub -all {:} $up_percentagelist " " up_percentagelist
	}
	if { [info exists cmdline(-lt)] } {
        set down_liplist [string toupper $cmdline(-lt)]
            set down_percentagelist $cmdline(-lc)
	    regsub -all {:} $down_liplist " " down_liplist
            regsub -all {:} $down_percentagelist " " down_percentagelist

	}
	set INLIP POPC
	if { [info exists cmdline(-lip)] } {
	set INLIP $cmdline(-lip)
	}

#### set global variable
global initmol


##### set sub lipids number to zero intitially
set dopcnum 0
set dspcum 0
set dapcnum 0
set dspenum 0
set dopenum 0
set dopgnum 0
set dopsnum 0
set cholnum 0
set gm3num 0
set pip2num 0
set pip3num 0
set gm1num 0
set gm3pnum 0
set gm3cnum 0
set dppinum 0
set pspinum 0

proc POPC {liplist exchange} {
}

proc CARD {liplist exchange} {
}

proc POPS {liplist exchange} {
	global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
	 foreach residue [lrange [random_list $liplist] 0 $exchange ] {

                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname POPS
		### delete selections
                $SUB delete
	}
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
		#set lip [atomselect $initmol "resname POPS"] # WG one less bead in new .itp version
                set lip [atomselect $initmol "resname POPS and not name C5B"]

		$lip writepdb POPS.pdb
                $lip delete
}


proc POPE {liplist exchange} {
	global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {

                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname POPE

		#Addition by W.G
		#set atomrep [atomselect $initmol "name NC3 and same residue as (resname POPE and resid $residue)"] 
		#$atomrep set name NH3

		### delete selections
                $SUB delete
		#$atomrep delete
        }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
		set lip [atomselect $initmol "resname POPE"]
		$lip writepdb POPE.pdb
                $lip delete
}

proc POPG {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {

                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname POPG
		### delete selections
		$SUB delete
        	}
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
		set lip [atomselect $initmol "resname POPG"]
                $lip writepdb POPG.pdb
		$lip delete
}

proc DHPC {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                
		#########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
		$SUB set resname DHPC
                ### delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname DHPC and not name D3B C4B C5B C3A C4A"]
                $lip writepdb DHPC.pdb
                $lip delete
}

proc DLPC {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
		#########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################                
		set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DLPC
                ### delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
		set lip [atomselect $initmol "resname DLPC and not name C4B C5B C4A"]
                $lip writepdb DLPC.pdb
                $lip delete
}

proc DPPC {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
		#########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DPPC
                ### delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
        	set lip [atomselect $initmol "resname DPPC and not name C5B"] 
                $lip writepdb DPPC.pdb
                $lip delete
}


proc DPPG {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DPPG
                ### delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname DPPG and not name C5B"]
                $lip writepdb DPPG.pdb
                $lip delete
}




proc DUPC {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {

                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
		set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DUPC
                ### delete selections
                $SUB delete

                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
        	set lip [atomselect $initmol "resname DUPC and not name C5B"] 
                $lip writepdb DUPC.pdb
                $lip delete
}
	
proc DPPE {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DPPE
                ### delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
        	set lip [atomselect $initmol "resname DPPE and not name C5B "] 
                $lip writepdb DPPE.pdb
                $lip delete
}	

proc DHPE {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DHPE
                ### delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
		set lip [atomselect $initmol "resname DHPE and not name D3B C4B C5B C3A C4A"]
                $lip writepdb DHPE.pdb
                $lip delete
}

proc DLPE {liplist exchange} {
        global initmol
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {

	       	#########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DLPE
                ### delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
        	set lip [atomselect $initmol "resname DLPE and not name C4B C5B C4A"] 
                $lip writepdb DLPE.pdb
                $lip delete
}

#proc PPCS {liplist exchange} {
proc DPSM {liplist exchange} {
        global initmol
	
	#WG - PPCS has been renamed DPSM, editing for the new structure...


	#################################################################
        #                                                       	#
        #      	1) Randomize lipid list 				#
	#	2) Run through first lipids until exchange number	#
        #                                                       	#
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
		#########################################################
                #                                                       #
		# 	Set new lipid resname				#
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #$SUB set resname PPCS
		$SUB set resname DPSM
		
		### Cleanup - delete selections
                $SUB delete

                }
		#########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
		#	2) Write a pdb-file				#
                #                                                       #
                #########################################################
        	#WG... set lip [atomselect $initmol "resname PPCS and not name C5B"] 
		set lip [atomselect $initmol "resname DPSM and not name C4B"]

                #$lip writepdb PPCS.pdb

		$lip writepdb DPSM.pdb

		$lip delete
}

proc CERA {liplist exchange} {
        global initmol

        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname CERA

                ### Cleanup - delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname CERA and name GL1 GL2 C1A C2A C3A C4A C1B C2B D3B C4B"]
                $lip writepdb CERA.pdb
                $lip delete
}



proc POPA {liplist exchange} {
        global initmol

        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname POPA

                ### Cleanup - delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname POPA and name PO4 GL1 GL2 C1A C2A C3A C4A C1B C2B D3B C4B C5B"]
                $lip writepdb POPA.pdb
                $lip delete
}


proc DAG {liplist exchange} {
        global initmol

        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname DAG

                ### Cleanup - delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname DAG and name PO4 GL1 GL2 C1A C2A C3A C4A C1B C2B D3B C4B C5B"]
                $lip writepdb DAG.pdb
                $lip delete
}




proc PVPG {liplist exchange} {
        global initmol

        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname PVPG

                ### Cleanup - delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname PVPG"]
                $lip writepdb PVPG.pdb
                $lip delete
}

proc PVPE {liplist exchange} {
        global initmol

        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname PVPE

                ### Cleanup - delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname PVPE"]
                $lip writepdb PVPE.pdb
                $lip delete
}

proc PVPA {liplist exchange} {
        global initmol

        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname PVPA

                ### Cleanup - delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname PVPA and name PO4 GL1 GL2 C1A C2A C3A C4A C1B C2B D3B C4B C5B"]
                $lip writepdb PVPA.pdb
                $lip delete
}


proc PCS {liplist exchange} {
        global initmol

        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                $SUB set resname PCS

                ### Cleanup - delete selections
                $SUB delete
                }
                #########################################################
                #                                                       #
                #       1) Set selection of beads needed                #
                #       2) Write a pdb-file                             #
                #                                                       #
                #########################################################
                set lip [atomselect $initmol "resname PCS and name PO4 GL2 C1A C2A C3A C4A"]
                $lip writepdb PCS.pdb
                $lip delete
}





#
#################################################################################
#										#
#	LIPIDS BEING ALIGNED INSTEAD OF RENAMED:				#
#	DOPC,DSPC, DAPC, DSPE, DOPE, DOPG, DOPS, PIP2, PIP3, GM3 and CHOL	#
#   DPPI PSPI                                                                   #
#										#
#################################################################################

proc DOPC {liplist exchange} {
        global initmol dopcnum
	### set variable to incr outputnames
        if { $dopcnum == 0 } {
        set h 1
        }
        if { $dopcnum > 0 } {
        set h $dopcnum
        }
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
		set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
		#########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit 	#
		#	between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
		set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
		set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
		$C1A set name C1B
		$C1B set name C1A

		#########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
		mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/dopc.pdb
		### get molid
		set mol1 [molinfo top get id]

		#########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
		#	atoms to be used during alignment               #
                #                                                       #
                #########################################################
		set lip_all [atomselect $mol1 all]
		$lip_all set resname DOPC
		set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 C1A C1B"]
		set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A C1B)"]
		#########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC		#
                #                                                       #
                #########################################################
		$lip_all move [measure fit $lip_sub $popc_sub]
		
		#################################################################
                #                                                       	#
                #      set output format and write out pdb of aligned lipid     #
                #                                                       	#
                #################################################################
		set outformat [format "DOPC_%04d" [expr $h]]
		$lip_all writepdb $outformat.pdb
		### reset molid and increase h
		set mol1 0
		incr h 1

		#################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this 	#
		#  lipid is not included in the POPC output pdb     		#
                #                                                               #
                #################################################################
		$SUB set resname EXCLUDE
		 
                ### Cleanup - delete selections
                $SUB delete
		$lip_all delete
		$lip_sub delete
		$popc_sub delete
		$C1A delete 
		$C1B delete
                }
	set dopcnum $h
}

proc DSPC {liplist exchange} {
        global initmol dspcnum
        ### set variable to incr outputnames
        if { $dspcnum == 0 } {
        set h 1
        }
        if { $dspcnum > 0 } {
        set h $dspcnum
        }

	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                $C1A set name C1B
                $C1B set name C1A

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/dspc.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
		$lip_all set resname DSPC
                set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "DSPC_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE

                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                }
	set dspcnum $h
}

proc DAPC {liplist exchange} {
        global initmol dapcnum
        ### set variable to incr outputnames
        if { $dapcnum == 0 } {
        set h 1
        }
        if { $dapcnum > 0 } {
        set h $dapcnum
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                $C1A set name D1B
                $C1B set name D1A

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/dapc.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
		$lip_all set resname DAPC
                set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 D1A D1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 D1A D1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "DAPC_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE

                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                }
	set dapcnum $h
}
proc DSPE {liplist exchange} {
        global initmol dspenum
        ### set variable to incr outputnames
        if { $dspenum == 0 } {
        set h 1
        }
        if { $dspenum > 0 } {
        set h $dspenum
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                $C1A set name C1B
                $C1B set name C1A

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/dspe.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname DSPE
                set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "DSPE_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                }
	set dspenum $h
}

proc DOPE {liplist exchange} {
        global initmol dopenum
        ### set variable to incr outputnames
        if { $dopenum == 0 } {
        set h 1
        }
        if { $dopenum > 0 } {
        set h $dopenum
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                $C1A set name C1B
                $C1B set name C1A

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/dope.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname DOPE
                set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "DOPE_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                }
	set dopenum $h
}

proc DOPG {liplist exchange} {
        global initmol dopgnum
        ### set variable to incr outputnames
        if { $dopgnum == 0 } {
        set h 1
        }
        if { $dopgnum > 0 } {
        set h $dopgnum
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                $C1A set name C1B
                $C1B set name C1A

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/dopg.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname DOPG
                set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "DOPG_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                }
	set dopgnum $h
}

proc DOPS {liplist exchange} {
        global initmol dopsnum
        ### set variable to incr outputnames
        if { $dopsnum == 0 } {
        set h 1
        }
        if { $dopsnum > 0 } {
        set h $dopsnum
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                $C1A set name C1B
                $C1B set name C1A

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/dops.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname DOPS
                set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "DOPS_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                }
	set dopsnum $h
}

proc CHOL {liplist exchange} {
        global initmol cholnum
        ### set variable to incr outputnames
	if { $cholnum == 0 } {
	puts "cholnum==0" 
	set h 1
	}
	if { $cholnum > 0 } {
	puts "cholnum > 0"
        set h $cholnum
        }
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set PO4 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name PO4"]
		set GL1 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name GL1"]
               

		#W.G... set D3B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name D3B"] 

                set C3B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C3B"]

                
		#W.G... set C2A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C2A"]

		set D2A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name D2A"]
		

		$PO4 set name ROH
		$GL1 set name R1
                #$D3B set name C2
		$C3B set name C2
		#$C2A set name C1
		$D2A set name C1
                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                #mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/chol.pdb
                mol load pdb /biggin/b123/sedm5059/SCRIPTS/exchange_lipids/testing/lipid_pdbs/chol_wg.pdb

		### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname CHOL
                set lip_sub [atomselect $mol1 "name ROH R1 C1 C2"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name ROH R1 C1 C2)"]
                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "CHOL_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE

                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $PO4 delete
		$GL1 delete
                #$D3B delete
		$C3B delete
		#$C2A delete
		$D2A delete
                }
	set cholnum $h
}

proc GM3P {liplist exchange} {
        global initmol gm3pnum
        ### set variable to incr outputnames
        if { $gm3pnum == 0 } {
        set h 1
        }
        if { $gm3pnum > 0 } {
        set h $gm3pnum
        }
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                set GL1 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name GL1"]
                set GL2 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name GL2"]
                $C1A set name D1B
                $C1B set name C1A
                $GL1 set name AM1
                $GL2 set name AM2
                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/gm3.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname GM3P
                set lip_sub [atomselect $mol1 "name AM1 AM2 C1A D1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name AM1 AM2 C1A D1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "GM3P_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                $GL1 delete
                $GL2 delete
                }
        set gm3pnum $h
}

proc GM3 {liplist exchange} {
        global initmol gm3num
        ### set variable to incr outputnames
        if { $gm3num == 0 } {
        set h 1
        }
        if { $gm3num > 0 } {
        set h $gm3num
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
		set GL1 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name GL1"]
                set GL2 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name GL2"]
                $C1A set name D1B
                $C1B set name C1A
		$GL1 set name AM1
                $GL2 set name AM2
                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                #WG edit... mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/gm3.pdb
                
		mol load pdb /biggin/b123/sedm5059/SCRIPTS/exchange_lipids/testing/lipid_pdbs/gm3_wg.pdb

		### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname GM3
                # WG edit... set lip_sub [atomselect $mol1 "name AM1 AM2 C1A D1B"]
                set lip_sub [atomselect $mol1 "name AM1 AM2 T1A C1B"]
		set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name AM1 AM2 C1A D1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "GM3_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
		$GL1 delete
		$GL2 delete
                }
	set gm3num $h
}

proc GM1 {liplist exchange} {
        global initmol gm1num
        ### set variable to incr outputnames
        if { $gm1num == 0 } {
        set h 1
        }
        if { $gm1num > 0 } {
        set h $gm1num
        }
        #################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set C1A [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1A"]
                set C1B [atomselect $initmol "same residue as (resname POPC and resid $residue) and name C1B"]
                set GL1 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name GL1"]
                set GL2 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name GL2"]
                $C1A set name C1B
                $C1B set name C1A
                $GL1 set name AM1
                $GL2 set name AM2
                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/gm1.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname GM1
                set lip_sub [atomselect $mol1 "name AM1 AM2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name AM1 AM2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "GM1_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $C1A delete
                $C1B delete
                $GL1 delete
                $GL2 delete
                }
        set gm1num $h
}








proc PIP2 {liplist exchange} {
        global initmol pip2num
        ### set variable to incr outputnames
        if { $pip2num == 0 } {
        set h 1
        }
        if { $pip2num > 0 } {
        set h $pip2num
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                ###########################################################################
                #                                                       		  #
                #       Rename C1A and C1B (WG version: D2A) to get the correct fit       #
                #       between lipids (different order in itp file)    		  #
                #                                                       		  #
                ###########################################################################
                set PO4 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name PO4"]
                #$PO4 set name PO3 
		$PO4 set name PO4
			
                #########################################################
                #                                                       #
                #       Load lipid to exchange with                     #
                #                                                       #
                #########################################################

                #mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/pip2.pdb
                mol load pdb /biggin/b123/sedm5059/SCRIPTS/exchange_lipids/testing/lipid_pdbs/pip2_wg.pdb

		### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                # WG... $lip_all set resname PIP
		$lip_all set resname PIP2
                #set lip_sub [atomselect $mol1 "name PO3 GL1 GL2 C1A C1B"]
                
		set lip_sub [atomselect $mol1 "name PO4 GL1 GL2 C1A D2A"]

		#set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A C1B)"]

		set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO4 GL1 GL2 C1A D2A)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "PIP2_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $PO4 delete
                }
	set pip2num $h
}

proc PIP3 {liplist exchange} {
        global initmol pip3num
        ### set variable to incr outputnames
        if { $pip3num == 0 } {
        set h 1
        }
        if { $pip3num > 0 } {
        set h $pip3num
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set PO4 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name PO4"]
                $PO4 set name PO3

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   	#
                #                                                       #
                #########################################################
                mol load pdb /sansom/s91/bioc1127/gp130/SCRIPTS/EXCHANGE_LIPIDS/lipids/pip3.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname PI3
                set lip_sub [atomselect $mol1 "name PO3 GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name PO3 GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "PIP3_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $PO4 delete
                }
	set pip3num $h
}

proc DPPI {liplist exchange} {
        global initmol dppinum
        ### set variable to incr outputnames
        if { $dppinum == 0 } {
        set h 1
        }
        if { $dppinum > 0 } {
        set h $dppinum
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set PO4 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name PO4"]
                $PO4 set name CP

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s105/bioc1280/Simulations/Tools/exchange_lipid/dppi.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname PPI
                set lip_sub [atomselect $mol1 "name CP GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name CP GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "DPPI_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $PO4 delete
                }
	set dppinum $h
}

proc PSPI {liplist exchange} {
        global initmol pspinum
        ### set variable to incr outputnames
        if { $pspinum == 0 } {
        set h 1
        }
        if { $pspinum > 0 } {
        set h $pspinum
        }
	#################################################################
        #                                                               #
        #       1) Randomize lipid list                                 #
        #       2) Run through first lipids until exchange number       #
        #                                                               #
        #################################################################
         foreach residue [lrange [random_list $liplist] 0 $exchange ] {
                #########################################################
                #                                                       #
                #       Set new lipid resname                           #
                #                                                       #
                #########################################################
                set SUB [atomselect $initmol "same residue as (resname POPC and resid $residue)"]
                #########################################################
                #                                                       #
                #       Rename C1A and C1B to get the correct fit       #
                #       between lipids (different order in itp file)    #
                #                                                       #
                #########################################################
                set PO4 [atomselect $initmol "same residue as (resname POPC and resid $residue) and name PO4"]
                $PO4 set name CP

                #########################################################
                #                                                       #
                #       Load lipid to exchange with                   #
                #                                                       #
                #########################################################
                mol load pdb /sansom/s105/bioc1280/Simulations/Tools/exchange_lipid/pspi.pdb
                ### get molid
                set mol1 [molinfo top get id]

                #########################################################
                #                                                       #
                #      Make a selection of entire lipid residue and the #
                #       atoms to be used during alignment               #
                #                                                       #
                #########################################################
                set lip_all [atomselect $mol1 all]
                $lip_all set resname SPI
                set lip_sub [atomselect $mol1 "name CP GL1 GL2 C1A C1B"]
                set popc_sub [atomselect $initmol "same residue as (resname POPC and resid $residue) and (name CP GL1 GL2 C1A C1B)"]

                #########################################################
                #                                                       #
                #      Move lipid to the best fit with POPC             #
                #                                                       #
                #########################################################
                $lip_all move [measure fit $lip_sub $popc_sub]

                #################################################################
                #                                                               #
                #      set output format and write out pdb of aligned lipid     #
                #                                                               #
                #################################################################
                set outformat [format "PSPI_%04d" [expr $h]]
                $lip_all writepdb $outformat.pdb
                ### reset molid and increase h
                set mol1 0
                incr h 1

                #################################################################
                #                                                               #
                #  Set the POPC used in alignment to EXCLUDE to ensure this     #
                #  lipid is not included in the POPC output pdb                 #
                #                                                               #
                #################################################################
                $SUB set resname EXCLUDE
                ### Cleanup - delete selections
                $SUB delete
                $lip_all delete
                $lip_sub delete
                $popc_sub delete
                $PO4 delete
                }
	set pspinum $h
}

	#################################################
	#						#
	#	Randomize list program			#
	#						#
	#################################################
  proc K { x y } { set x }

 proc random_list { list } {
      set n [llength $list]
      while {$n>0} {
          set j [expr {int(rand()*$n)}]
          lappend slist [lindex $list $j]
          incr n -1
          set temp [lindex $list $n]
          set list [lreplace [K $list [set list {}]] $j $j $temp]
      }
      return $slist
}

	#################################################
        #                                               #
        #       Load the system                         #
        #                                               #
        #################################################
	mol load gro $grofile
	set initmol [molinfo top get id]
	puts "$initmol =initmol"

	#################################################
        #                                               #
        #       Test membrane type                      #
        #                                               #
        #################################################
	if { $INLIP == "POPS" } {
		puts "changing POPS to POPC"
		set POPS [atomselect top "resname POPS"]
		$POPS set resname POPC
		$POPS delete
		}
	 if { $INLIP == "POPE" } {
		puts "changing POPE to POPC"
                set POPE [atomselect top "resname POPE"]
                $POPE set resname POPC
                $POPE delete
		}
	 if { $INLIP == "POPG" } {
		puts "changing POPG to POPC"
                set POPG [atomselect top "resname POPG"]
                $POPG set resname POPC
		$POPG delete
                }
	 if { $INLIP == "PVPE" } {
		puts "changing PVPE to POPC"
                set PVPE [atomselect top "resname PVPE"]
                $PVPE set resname POPC
		$PVPE delete
                }
	 if { $INLIP == "PVPG" } {
		puts "changing PVPG to POPC"
        	set PVPG [atomselect top "resname PVPG"]
                $PVPG set resname POPC
                $PVPG delete
                }
	  if { $INLIP == "" } {
		puts "No INPLIP keeping POPC"
                set $INLIP POPC
                }


	
        #################################################
        #                                               #
        #       Set selection and move to (0,0,0)       #
        #                                               #
        #################################################
	set all [atomselect $initmol all]
	set membrane [measure center [atomselect $initmol "resname POPC"] weight mass]
	$all move [trans origin $membrane]


        #################################################
        #                                               #
        #       Get upper, lower and total lipid 	#
	#	selection      				#
        #                                               #
        #################################################
	set lower [atomselect $initmol "(resname POPC and name PO4) and z < 0"]
	set upper [atomselect $initmol "(resname POPC and name PO4) and z > 0"]
	set totlip [atomselect $initmol "resname POPC and name PO4"]

	
	#################################################
        #                                               #
        #       Get resids and number of molecules 	#
	#	in each selection    			#
        #                                               #
        #################################################
	set totlist [$totlip get resid]
	set tot_num [$totlip num]

	set lowerlist [$lower get resid]
	set lower_num [$lower num]

	set upperlist [$upper get resid]
	set upper_num [$upper num]


#########################################
#					#
#	DO THE LIPID EXCHANGE		#
#					#
#########################################

#########################################################
#							#
#	Test if upper leaflet has been specified	#
#	If yes, then exchange				#
#							#
#########################################################
if { [info exists cmdline(-ut)] } {
	### set i to one to ignore the first lipid which is POPC
	set i 0
	#########################################################
	#                                                       #
	#      Run through all lipids in upper leaflet	        #
	#                                                       #
	#########################################################
	foreach lip [lrange $up_liplist 0 end] {
		#########################################################
	        #                                                       #
        	#      Find number of lipids to exchange:		#
		#	The -1 corrects for tcl starting at 0 and not 1 #
	        #                                                       #
        	#########################################################
		set lip_exchange [expr {round(($upper_num / ([expr 100.0 / [lindex $up_percentagelist $i]])) - 1)} ]
		
		#########################################################
                #                                                       #
                #      RUN the lipid procedure               		#
                #      $lip is the lipid specific proc defined above	#
                #                                                       #
                #########################################################
                $lip $upperlist $lip_exchange
                
		
		#########################################################
                #                                                       #
                #      	Reset the lipid list now that some of the	# 
		# 	lipids have been changes to another type        #
                #                                                       #
                #########################################################
                set upper [atomselect $initmol "(resname POPC and name PO4) and z > 0"]
                set upperlist [$upper get resid]
		### reset variables and increase i                
		set lip_exchange 0
                incr i
	}
}

#########################################################
#                                                       #
#       Test if lower leaflet has been specified        #
#       If yes, then exchange                           #
#                                                       #
#########################################################

if { [info exists cmdline(-lt)] } {
	### set j to one to ignore the first lipid which is POPC
	set j 0

	#########################################################
        #                                                       #
        #      Run through all lipids in lower leaflet          #
        #                                                       #
        #########################################################
        foreach lip [lrange $down_liplist 0 end] {
		#########################################################
                #                                                       #
                #      Find number of lipids to exchange:               #
                #       The -1 corrects for tcl starting at 0 and not 1 #
                #                                                       #
                #########################################################
                set lip_exchange [expr {round(($lower_num / ([expr 100.0 / [lindex $down_percentagelist $j]])) - 1)} ]
		
		#########################################################
                #                                                       #
                #      RUN the lipid procedure                          #
                #      $lip is the lipid specific proc defined above    #
                #                                                       #
                #########################################################
	        $lip $lowerlist $lip_exchange
                
		#########################################################
                #                                                       #
                #       Reset the lipid list now that some of the       # 
                #       lipids have been changes to another type        #
                #                                                       #
                #########################################################
		set lower [atomselect $initmol "(resname POPC and name PO4) and z < 0"]
                set lowerlist [$lower get resid]
		### reset variables and increase j
		set lip_exchange 0
		incr j
        }
}

	#################################
	#				#
	#	Set ions to water	#
	#	and write pdb		#
	#				#
	#################################
	set ions [atomselect $initmol "resname ION"]
	$ions set name W
	$ions set resname W
	set wat [atomselect $initmol "resname W"]
	$wat writepdb W.pdb
	
	#################################
        #                               #
        #       write out cholesterol 	#
	#	if present	        #
        #                               #
        #################################
#	set chol [atomselect $initmol "resname CHOL"]
#	if {[$chol num] > 0} {
#	$chol writepdb CHOL.pdb
#	}	

	#################################
        #                               #
        #       write remaining POPC    #
        #                               #
        #################################
	set popc [atomselect $initmol "resname POPC"]
	$popc writepdb POPC.pdb

	#########################################################
        #                               			#
        #       get full lipid list     			#
	#	Test if both leaflets are specified or just one	#
        #                               			#
        #########################################################
	 if { [info exists cmdline(-ut)] && [info exists cmdline(-lt)]} {	
		set lipidlist [lsort -unique [concat $up_liplist $down_liplist]]
		}
	if { ![info exists cmdline(-ut)]} {
		set lipidlist $down_liplist
	}
	if { ![info exists cmdline(-lt)]} {
        	set lipidlist $up_liplist
	}

	### set protein and write pdb
	set protein [atomselect $initmol "not resname $lipidlist PI3 PIP PPI SPI W CHOL EXCLUDE"]
	if { [$protein num] > 0 } {
	$protein writepdb PROTEIN.pdb
	}

exit
