-- doppelte egid in boflaeche
/*
SELECT bb.*
FROM
(
 SELECT gebaeudenummer_von, COUNT(gebaeudenummer_von) as num
 FROM av_avdpool_ch.bodenbedeckung_gebaeudenummer
 GROUP BY gebaeudenummer_von
 HAVING (COUNT(gebaeudenummer_von) > 1)
) as gebnum, 
av_avdpool_ch.bodenbedeckung_boflaeche as bb
WHERE bb.tid = gebnum.gebaeudenummer_von;
*/


SELECT bb.tid, gebnum.gwr_egid, bb.gem_bfs
FROM 
(
 SELECT tid, gem_bfs
 FROM av_avdpool_ch.bodenbedeckung_boflaeche
 WHERE gem_bfs = 2401
 AND art = 0
) as bb
LEFT OUTER JOIN 
(
 SELECT gwr_egid, gebaeudenummer_von
 FROM av_avdpool_ch.bodenbedeckung_gebaeudenummer 
 WHERE gem_bfs = 2401
) as gebnum 
ON bb.tid = gebnum.gebaeudenummer_von
ORDER BY bb.tid

SELECT *
FROM av_avdpool_ch.bodenbedeckung_boflaeche
WHERE gem_bfs = 2401 
AND art = 0


WITH geb AS (
 SELECT bb.tid, gebnum.gwr_egid, bb.geometrie, bb.gem_bfs
 FROM av_avdpool_ch.bodenbedeckung_boflaeche as bb, av_avdpool_ch.bodenbedeckung_gebaeudenummer as gebnum
 WHERE bb.art = 0
 AND bb.tid = gebnum.gebaeudenummer_von
),
adr AS (
 SELECT lokname.text as atext, ein.hausnummer, ein.gwr_egid, ein.gwr_edid, ein.lage, ein.gem_bfs
 FROM av_avdpool_ch.gebaeudeadressen_gebaeudeeingang as ein, av_avdpool_ch.gebaeudeadressen_lokalisationsname as lokname
 WHERE ein.gebaeudeeingang_von = lokname.benannte
 AND status = 1
 AND inaenderung = 1
 AND attributeprovisorisch = 1
 AND istoffiziellebezeichnung = 0
 AND im_gebaeude = 0
)

SELECT geb.geometrie, array_to_json(array_agg(geb.gwr_egid)), array_agg(adr.atext), array_agg(adr.hausnummer)
FROM geb, adr
WHERE geb.gem_bfs = 2544
AND adr.gem_bfs = 2544
AND ST_Intersects(geb.geometrie, adr.lage)
GROUP BY geb.geometrie 
--ORDER BY atext, hausnummer

--Pro Gemeinde -> pro Gebäude vorgehen. 
--Wenns einen EGID in der BB hat, darf der Verschnitt keine Adresse mit EGID liefern.
--Achtung auf die verschiedenen Bedingungen, wie istoffizielle etc. etc.
