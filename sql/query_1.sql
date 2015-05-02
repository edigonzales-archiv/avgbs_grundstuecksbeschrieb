/*
DROP TABLE av2gb_work.t_geb_adr;
CREATE TABLE av2gb_work.t_geb_adr
(
  ogc_fid serial NOT NULL,
  geb_tid character varying,
  geb_gwr_egid double precision,
  lokalisationsname character varying,
  hausnummer character varying,
  plz integer,
  zusatzziffern integer,
  ortschaft character varying,
  adr_gwr_egid double precision,
  gwr_edid double precision,
  lokalisationsart integer, -- 0: Benanntes Gebiet / 1: Strasse / 2: Platz
  geometrie geometry(Polygon,21781),
  lage geometry(Point,21781),
  gem_bfs integer,
  CONSTRAINT av2gb_work_t_geb_adr_pkey PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE av2gb_work.t_geb_adr
  OWNER TO stefan;
GRANT ALL ON TABLE av2gb_work.t_geb_adr TO stefan;
GRANT SELECT ON TABLE av2gb_work.t_geb_adr TO mspublic;

CREATE INDEX idx_av2gb_work_t_geb_adr_ogc_fid
  ON av2gb_work.t_geb_adr
  USING btree
  (ogc_fid);
  
CREATE INDEX idx_av2gb_work_t_geb_adr_gem_bfs
  ON av2gb_work.t_geb_adr
  USING btree
  (gem_bfs);

CREATE INDEX idx_av2gb_work_t_geb_adr_geometrie
  ON av2gb_work.t_geb_adr
  USING gist
  (geometrie);

CREATE INDEX idx_av2gb_work_t_geb_adr_lage
  ON av2gb_work.t_geb_adr
  USING gist
  (lage);
*/



WITH adr AS (
 SELECT *
 FROM av2gb_work.t_adr_plz_ort
 WHERE gem_bfs = 2549
 AND status = 1                     -- 0: projektiert / 1: real
 AND inaenderung = 1                -- 0: ja / 1: nein
 AND attributeprovisorisch = 1      -- 0: ja / 1: nein
 AND istoffiziellebezeichnung = 0   -- 0: ja / 1: nein
 AND im_gebaeude = 0                -- 0: BB / 1: EO
),
geb AS (
 SELECT *
 FROM av2gb_work.t_gebaeude_gebnum
 WHERE gem_bfs = 2549
)
SELECT geb.tid as geb_tid, geb.gwr_egid as geb_gwr_egid, adr.lokalisationsname, 
       adr.hausnummer, adr.plz, adr.zusatzziffern, adr.ortschaft, 
       adr.gwr_egid as adr_gwr_egid, adr.gwr_edid, adr.lokalisationsart,
       geb.geometrie, adr.lage, geb.gem_bfs
FROM geb LEFT OUTER JOIN adr ON ST_Intersects(geb.geometrie, adr.lage)
ORDER BY geb.gem_bfs, adr.plz, adr.lokalisationsname, adr.hausnummer;
