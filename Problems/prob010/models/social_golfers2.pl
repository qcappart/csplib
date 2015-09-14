/*

  Social golfer problem in B-Prolog.

  CSPLib problem 10:
  http://www.csplib.org/Problems/prob010/index.html
  """
  The coordinator of a local golf club has come to you with the following 
  problem. In her club, there are 32 social golfers, each of whom play golf 
  once a week, and always in groups of 4. She would like you to come up 
  with a schedule of play for these golfers, to last as many weeks as 
  possible, such that no golfer plays in the same group as any other golfer 
  on more than one occasion.

  Possible variants of the above problem include: finding a 10-week schedule 
  with ``maximum socialisation''; that is, as few repeated pairs as possible 
  (this has the same solutions as the original problem if it is possible 
  to have no repeated pairs), and finding a schedule of minimum length 
  such that each golfer plays with every other golfer at least once 
  (``full socialisation'').

  The problem can easily be generalized to that of scheduling m groups of 
  n golfers over p weeks, such that no golfer plays in the same group as any 
  other golfer twice (i.e. maximum socialisation is achieved). 
  """


  This model is a translation of the OPL code from 
  http://www.dis.uniroma1.it/~tmancini/index.php?currItem=research.publications.webappendices.csplib2x.problemDetails&problemid=010


  Model created by Hakan Kjellerstrand, hakank@gmail.com
  See also my B-Prolog page: http://www.hakank.org/bprolog/

*/

% Licenced under CC-BY-4.0 : http://creativecommons.org/licenses/by/4.0/

go :-
        Weeks = 5,
        Groups = 7,
        GroupSize = 3,
        Golfers is Groups * GroupSize,

        Golfer = 1..Golfers,
        Week = 1..Weeks,
        Group = 1..Groups,
       

        % decision variables
        new_array(Assign,[Golfers,Weeks]),
        array_to_list(Assign,Vars),
        Vars :: 1..Groups,
      
        % C1: Each group has exactly groupSize players
        foreach(Gr in Group, W in Week,
                 sum([(Assign[G,W] #= Gr) : G in Golfer]) #= GroupSize
                ),

        % C2: Each pair of players only meets at most once
        foreach(G1 in Golfer,G2 in Golfer, W1 in Week, W2 in Week,
                (G1 \= G2,
                 W1 \= W2 ->
                     (Assign[G1,W1] #= Assign[G2,W1]) + 
                     (Assign[G1,W2] #= Assign[G2,W2]) #=< 1
                ;
                     true
                )),


        labeling([ff], Vars),

        Rows @= Assign^rows,
        foreach(Row in Rows, writeln(Row)),
        nl.
