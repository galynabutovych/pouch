import MDAnalysis as mda
from MDAnalysis.analysis import distances
import sys, getopt

import sys, getopt

def main(argv):
   inputfile = ''
   outputfile = ''
   opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
   for opt, arg in opts:
      if  opt in ("-i", "--ifile"):
         inputfile = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
   print ('Input file is ', inputfile)
   print ('Output file is ', outputfile)
   u = mda.Universe(inputfile)
   #print(u.atoms.positions)

   HG = u.select_atoms("name Hg")
   N = u.select_atoms("name N")
   O = u.select_atoms("name O")

   file = open(outputfile, "w")

   file.write('Indices of atoms, starting at 0:\n')
   N.ix.tofile(file, sep=' ')
   file.write(' ')
   O.ix.tofile(file, sep=' ')
   file.write('\n')

   file.write('Distances from these atoms to Hg:\n')

   dist_arr = distances.distance_array(HG.positions, # reference
                                    N.positions, # configuration
                                    box=u.dimensions)
   dist_arr.tofile(file, sep=' & ', format='%s')

   dist_arr = distances.distance_array(HG.positions, # reference
                                    O.positions, # configuration
                                    box=u.dimensions)
   file.write(' & ')
   dist_arr.tofile(file, sep=' & ', format='%s')

   file.write('\n')
   file.close()



if __name__ == "__main__":
    main(sys.argv[1:])
