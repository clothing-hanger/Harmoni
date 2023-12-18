import os, sys, yaml

global quaMap, ritc, string
ritc = ""



if __name__ == "__main__":
    # get our file arg
    if len(sys.argv) < 2:
        print("Usage: python Convert.py <file>")
        sys.exit(1)

    # get our file
    file = sys.argv[1]
    if not os.path.isfile(file):
        print("File does not exist")
        sys.exit(1)

    # open our file
    with open(file, "r") as f:
        quaMap = yaml.safe_load(f)

    ritc += "return {\n"


    for hit in quaMap["HitObjects"]:
        # get our start/end times
        start = hit["StartTime"]
        ritc += "\t{" + str(start) + "," + str(hit["Lane"]) + "},\n"
    ritc += "}"

    # save our file
    with open(file[:-4] + ".ritc", "w") as f:
        f.write(ritc)

    print("Done!")