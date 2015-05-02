 SELECT tid, count(tid) as num
 FROM av2gb_work.t_gebaeude_gebnum
 GROUP BY tid
 HAVING (count(tid) > 1)

/*
DROP TABLE av2gb_work.t_adr_plz_ort;
CREATE TABLE av2gb_work.t_adr_plz_ort
(
  ogc_fid serial NOT NULL,
  lokalisationsname character varying,
  hausnummer character varying,
  plz integer,
  zusatzziffern integer,
  ortschaft character varying,
  gebaeudeeingang_von character varying,
  status integer,
  inaenderung integer,
  attributeprovisorisch integer,
  istoffiziellebezeichnung integer,
  lage geometry(Point,21781),
  hoehenlage double precision,
  im_gebaeude integer,
  gwr_egid double precision,
  gwr_edid double precision,
  lokalisationsart integer,
  gem_bfs integer,
  CONSTRAINT av2gb_work_t_adr_plz_ort_pkey PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE av2gb_work.t_adr_plz_ort
  OWNER TO stefan;
GRANT ALL ON TABLE av2gb_work.t_adr_plz_ort TO stefan;
GRANT SELECT ON TABLE av2gb_work.t_adr_plz_ort TO mspublic;

CREATE INDEX idx_av2gb_work_t_adr_plz_ort_ogc_fid
  ON av2gb_work.t_adr_plz_ort
  USING btree
  (ogc_fid);
  
CREATE INDEX idx_av2gb_work_t_adr_plz_ort_gem_bfs
  ON av2gb_work.t_adr_plz_ort
  USING btree
  (gem_bfs);

CREATE INDEX idx_av2gb_work_t_adr_plz_ort_lage
  ON av2gb_work.t_adr_plz_ort
  USING gist
  (lage);
*/


/*
WITH adr AS (
SELECT ein.*, lokname.text as atext
FROM av_avdpool_ch.gebaeudeadressen_gebaeudeeingang as ein, av_avdpool_ch.gebaeudeadressen_lokalisationsname as lokname
WHERE ein.gem_bfs = 2549
AND lokname.gem_bfs = 2549
AND ein.gebaeudeeingang_von = lokname.benannte
),
ort AS (
 SELECT os.flaeche, osname.atext
 FROM plz_ortschaft.plzortschaft_ortschaft as os, plz_ortschaft.plzortschaft_ortschaftsname as osname, av_avdpool_ch.gemeindegrenzen_gemeindegrenze as gem
 WHERE gem.gem_bfs = 2549
 AND ST_Intersects(gem.geometrie, os.flaeche)
 AND os.t_id = osname.ortschaftsname_von
 AND os.status IN (0,1)
 AND os.inaenderung = 1
),
plz AS (
 SELECT plz, zusatzziffern, flaeche
 FROM plz_ortschaft.plzortschaft_plz6 as plz, av_avdpool_ch.gemeindegrenzen_gemeindegrenze as gem
 WHERE gem.gem_bfs = 2549
 AND ST_Intersects(gem.geometrie, plz.flaeche)
 AND plz.status IN (0,1)
 AND plz.inaenderung = 1
)
SELECT adr.atext, adr.hausnummer, plz.plz, plz.zusatzziffern, ort.atext, adr.gebaeudeeingang_von, adr.status, adr.inaenderung, adr.attributeprovisorisch, adr.istoffiziellebezeichnung, adr.lage, adr.hoehenlage, adr.im_gebaeude, adr.gwr_egid, adr.gwr_edid, adr.gem_bfs
FROM adr, ort, plz
WHERE adr.gem_bfs = 2549
AND ST_Intersects(adr.lage, ort.flaeche)
AND ST_Intersects(adr.lage, plz.flaeche)
*/
