# For MinimalImagePerm
BTKit_Con.InCosetSimple := function(n, group, perm)
    local orbList,getOrbits, r, invperm,minperm;
    invperm := perm^-1;

    getOrbits := function(pointlist)
        local orbs, array, i, j;

        orbs := StabTreeStabilizerOrbits(group, pointlist, [1..n]);

        array := [];

        for i in [1..Length(orbs)] do
            for j in orbs[i] do
                array[j] := i;
            od;
        od;
        #Print(group, pointlist, orbs, array, "\n");
        return array;
    end;

    r := rec(
        name := "InGroupSimple",
        image := {p} -> RightCoset(group, p),
        result := {} -> RightCoset(group, perm),
        check := {p} -> p in RightCoset(group, perm),
        refine := rec(
            initialise := function(ps, buildingRBase)
                return r!.refine.fixed(ps, buildingRBase);
            end,
            fixed := function(ps, buildingRBase)
                local fixedpoints, points, p;
                fixedpoints := PS_FixedPoints(ps);
                
                if buildingRBase then
                    p := ();
                else
                    p := invperm;
                fi;

                fixedpoints := OnTuples(fixedpoints, p);
                points := getOrbits(fixedpoints);

                return {x} -> points[x^p];
            end)
        );
        return Objectify(BTKitRefinerType, r);
    end;

BTKit_Con.InGroupSimple := {n, group} -> BTKit_Con.InCosetSimple(n, group, ());
