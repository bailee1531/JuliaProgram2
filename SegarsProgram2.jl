# Bailee Segars
# SegarsProgram2.jl
# CS 424-01 Fall 2024
# This program takes baseball player data from a file, completes
# calculations, then outputs the sorted information
# Used VSCode 1.93.1 on Windows 11

using Printf
using Statistics

#=
This function calculates the batting average
Parameters: hits, atBats
Return value: Calculated batting average
BattingAvg calculates the batting average by dividing the given parameters
=#
function BattingAvg(hits, atBats)
    return hits/atBats
end


#=
This function calculates the slugging percentage
Parameters: singles, doubles, triples, homeRuns, atBats
Return value: Calculated slugging percentage
SluggingPerc calculates the batting average by averaging hits and atBats
=#
function SluggingPerc(singles, doubles, triples, homeRuns, atBats)
    return (singles + (2*doubles) + (3*triples) + (4*homeRuns))/atBats
end


#=
This function calculates on base percentage
Parameters: hits, walks, hitByPitch, plateAppear
Return value: Calculated on base percentage
OnBasePerc calculates the OBP by adding hits, walks, hitByPitch and dividing the sum by plateAppearances
=#
function OnBasePerc(hits, walks, hitsByPitch, plateAppear)
    return (hits + walks + hitsByPitch)/plateAppear
end

#Prompts the user to enter a file name
println("Enter the data file name")
fileName = readline()

#Attempts to open the file
file = try
   open(fileName,"r")
catch e
    println("Unable to open file\n")
    exit()
end

lineArray = readlines(file)     #Creates an array of the data lines in the file
numPlayers = length(lineArray)  #Uses array length to determine how many players are in the file
playerStats = Matrix{Any}(undef, numPlayers, 5)     #Creates a multidimensional array. dim 1 = rows: determined by number of players. dim 2 = columns: 5 stats

#For loop to iterate through the line array
for line in eachindex(lineArray)
    player = split(lineArray[line])     #Splits the string into an array of one player's stats
    firstName = player[1]               
    lastName = player[2]
    plateAppear = parse(Float64, player[3])
    atBats = parse(Float64, player[4])
    singles = parse(Float64, player[5])
    doubles = parse(Float64, player[6])
    triples = parse(Float64, player[7])
    homeRuns = parse(Float64, player[8])
    walks = parse(Float64, player[9])
    hitsByPitch = parse(Float64, player[10])

    hits = singles + doubles + triples + homeRuns

    global playerStats[line, 1] = firstName     #Replaces undef with firstName in 1st column of current row
    global playerStats[line, 2] = lastName      #Replaces undef with lastName in 2nd column of current row
    global playerStats[line, 3] = BattingAvg(hits, atBats)     #Replaces undef with calculated avg in 3rd column of current row
    global playerStats[line, 4] = SluggingPerc(singles, doubles, triples, homeRuns, atBats)  #Replaces undef with calculated slugging % in 4th column of current row
    global playerStats[line, 5] = OnBasePerc(hits, walks, hitsByPitch, plateAppear)     #Replaces undef with calculated obp in 5th column of current row
end


println("\nBASEBALL STATS REPORT --- ", numPlayers, " PLAYERS FOUND IN FILE")

println("REPORT ORDERED BY SLUGGING %\n")
println("PLAYER NAME\t:\tAVERAGE\t\tSLUGGING\tONBASE%")
println("----------------------------------------------------------------------")
playerStats = playerStats[sortperm(playerStats[:,4], rev = true), :]    #Reverse sorts the rows based on the 4th column (slugging percentage)
for num in 1:numPlayers     #Iterates through all rows by using the number of players as the counter
    @printf("%s, %s\t:\t%.3f\t\t%.3f\t\t%.3f\n", playerStats[num,2], playerStats[num,1], playerStats[num,3], playerStats[num,4], playerStats[num,5])
end

println("\n\nREPORT ORDERED BY PLAYER NAME\n")
println("PLAYER NAME\t:\tAVERAGE\t\tSLUGGING\tONBASE%")
println("----------------------------------------------------------------------")

playerStats = sortslices(playerStats, dims = 1, by = playerStats -> (playerStats[2], playerStats[1]))     #Sorts the rows based on the 2nd column (last name), then breaks ties with the 1st column (first name)
for num in 1:numPlayers     #Iterates through all rows by using the number of players as the counter
    @printf("%s, %s\t:\t%.3f\t\t%.3f\t\t%.3f\n", playerStats[num,2], playerStats[num,1], playerStats[num,3], playerStats[num,4], playerStats[num,5])
end

close(file)