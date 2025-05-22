--1 Total Seats
SELECT 
DISTINCT COUNT (Parliament_Constituency) AS Total_Seats
FROM constituencywise_results


--What is the total number of seats available for elections in each state
SELECT 
s.State AS State_Name,
COUNT(cr.Constituency_ID) AS Total_Seats_Available
FROM constituencywise_results cr
JOIN 
statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN 
states s ON sr.State_ID = s.State_ID
GROUP BY 
s.State
ORDER BY 
s.State;


--Total Seats Won by NDA Alliance

SELECT 
SUM(CASE 
WHEN party IN (
'Bharatiya Janata Party - BJP', 
'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS', 
'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 
'Asom Gana Parishad - AGP',
'Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP', 
'Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD', 
'Sikkim Krantikari Morcha - SKM'
) 
THEN "won"
ELSE 0 
END) AS NDA_Total_Seats_Won
FROM 
partywise_results



--Seats Won by NDA Allianz Parties
SELECT 
party as Party_Name,
won as Seats_Won
FROM 
partywise_results
WHERE 
party IN (
'Bharatiya Janata Party - BJP', 
'Telugu Desam - TDP', 
'Janata Dal  (United) - JD(U)',
'Shiv Sena - SHS', 
'AJSU Party - AJSUP', 
'Apna Dal (Soneylal) - ADAL', 
'Asom Gana Parishad - AGP',
'Hindustani Awam Morcha (Secular) - HAMS', 
'Janasena Party - JnP', 
'Janata Dal  (Secular) - JD(S)',
'Lok Janshakti Party(Ram Vilas) - LJPRV', 
'Nationalist Congress Party - NCP',
'Rashtriya Lok Dal - RLD', 
'Sikkim Krantikari Morcha - SKM'
)
ORDER BY Seats_Won DESC



--Total Seats Won by I.N.D.I.A. Alliance
SELECT 
SUM(CASE 
WHEN party IN (
'Indian National Congress - INC',
'Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK'
) 
THEN "won"
ELSE 0 
END) AS INDIA_Total_Seats_Won
FROM 
partywise_results



--Seats Won by I.N.D.I.A. Alliance Parties
SELECT 
party as Party_Name,
won as Seats_Won
FROM 
partywise_results
WHERE 
party IN (
'Indian National Congress - INC',
'Aam Aadmi Party - AAAP',
'All India Trinamool Congress - AITC',
'Bharat Adivasi Party - BHRTADVSIP',
'Communist Party of India  (Marxist) - CPI(M)',
'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
'Communist Party of India - CPI',
'Dravida Munnetra Kazhagam - DMK',
'Indian Union Muslim League - IUML',
'Nat`Jammu & Kashmir National Conference - JKN',
'Jharkhand Mukti Morcha - JMM',
'Jammu & Kashmir National Conference - JKN',
'Kerala Congress - KEC',
'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
'Rashtriya Janata Dal - RJD',
'Rashtriya Loktantrik Party - RLTP',
'Revolutionary Socialist Party - RSP',
'Samajwadi Party - SP',
'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
'Viduthalai Chiruthaigal Katchi - VCK'
)
ORDER BY Seats_Won DESC


--Add new column field in table partywise_results to get the Party Alliance as NDA, I.N.D.I.A and OTHER
ALTER TABLE partywise_results
ADD party_alliance VARCHAR(50);
select * from partywise_results

select party_alliance,
sum(won) from partywise_results
group by party_alliance 


--Winning candidate's name, their party name, total votes, and the margin of victory for a 
--specific state and constituency?
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'partywise_results';

ALTER TABLE partywise_results
ALTER COLUMN party_id TYPE INT USING party_id::INTEGER

SELECT 
cr.Winning_Candidate,
p.Party,
p.party_alliance,
cr.Total_Votes,
cr.Margin,
cr.Constituency_Name,
s.State
FROM constituencywise_results cr JOIN partywise_results p ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE  cr.Constituency_Name = 'WARANGAL'


--What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
SELECT 
cd.Candidate,
cd.Party,
cd.EVM_Votes,
cd.Postal_Votes,
cd.Total_Votes,
cr.Constituency_Name
FROM constituencywise_details cd
JOIN constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
WHERE cr.Constituency_Name = 'WARANGAL'
ORDER BY cd.Total_Votes DESC;



--Which candidate received the highest number of EVM votes in each constituency (Top 10)?
SELECT 
cr.Constituency_Name,
cd.Constituency_ID,
cd.Candidate,
cd.EVM_Votes
FROM 
constituencywise_details cd
JOIN 
constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
WHERE 
cd.EVM_Votes = (
SELECT MAX(cd1.EVM_Votes)
FROM constituencywise_details cd1
WHERE cd1.Constituency_ID = cd.Constituency_ID)
ORDER BY 
cd.EVM_Votes DESC;






