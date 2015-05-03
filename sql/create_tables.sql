CREATE SCHEMA av_gb2av_work
  AUTHORIZATION stefan;

GRANT ALL ON SCHEMA av_gb2av_work TO stefan;
GRANT USAGE ON SCHEMA av_gb2av_work TO mspublic;

-- Gebäude mit EGID-Zuweisung
--DROP TABLE av_gb2av_work.t_gebaeude_gebnum;
CREATE TABLE av_gb2av_work.t_gebaeude_gebnum
(
  ogc_fid serial NOT NULL,
  tid character varying,
  gwr_egid double precision,
  geometrie geometry(Polygon,21781),
  gem_bfs integer,
  CONSTRAINT av_gb2av_work_t_gebaeude_gebnum_pkey PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE av_gb2av_work.t_gebaeude_gebnum
  OWNER TO stefan;
GRANT ALL ON TABLE av_gb2av_work.t_gebaeude_gebnum TO stefan;
GRANT SELECT ON TABLE av_gb2av_work.t_gebaeude_gebnum TO mspublic;

CREATE INDEX idx_av_gb2av_work_t_gebaeude_gebnum_ogc_fid
  ON av_gb2av_work.t_gebaeude_gebnum
  USING btree
  (ogc_fid);

CREATE INDEX idx_av_gb2av_work_t_gebaeude_gebnum_tid
  ON av_gb2av_work.t_gebaeude_gebnum
  USING btree
  (tid);  
  
CREATE INDEX idx_av_gb2av_work_t_gebaeude_gebnum_gem_bfs
  ON av_gb2av_work.t_gebaeude_gebnum
  USING btree
  (gem_bfs);

CREATE INDEX idx_av_gb2av_work_t_gebaeude_gebnum_geometrie
  ON av_gb2av_work.t_gebaeude_gebnum
  USING gist
  (geometrie);

-- Adressen mit PLZ/Ortschaft
--DROP TABLE av_gb2av_work.t_adr_plz_ort;
CREATE TABLE av_gb2av_work.t_adr_plz_ort
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
  CONSTRAINT av_gb2av_work_t_adr_plz_ort_pkey PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE av_gb2av_work.t_adr_plz_ort
  OWNER TO stefan;
GRANT ALL ON TABLE av_gb2av_work.t_adr_plz_ort TO stefan;
GRANT SELECT ON TABLE av_gb2av_work.t_adr_plz_ort TO mspublic;

CREATE INDEX idx_av_gb2av_work_t_adr_plz_ort_ogc_fid
  ON av_gb2av_work.t_adr_plz_ort
  USING btree
  (ogc_fid);
  
CREATE INDEX idx_av_gb2av_work_t_adr_plz_ort_gem_bfs
  ON av_gb2av_work.t_adr_plz_ort
  USING btree
  (gem_bfs);

CREATE INDEX idx_av_gb2av_work_t_adr_plz_ort_lage
  ON av_gb2av_work.t_adr_plz_ort
  USING gist
  (lage);

-- Gebäude mit Gebäudeadressen
-- Gebäudegeomtrie kann mehrfach vorkommen
--DROP TABLE av_gb2av_work.t_geb_adr;
CREATE TABLE av_gb2av_work.t_geb_adr
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
  CONSTRAINT av_gb2av_work_t_geb_adr_pkey PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE av_gb2av_work.t_geb_adr
  OWNER TO stefan;
GRANT ALL ON TABLE av_gb2av_work.t_geb_adr TO stefan;
GRANT SELECT ON TABLE av_gb2av_work.t_geb_adr TO mspublic;

CREATE INDEX idx_av_gb2av_work_t_geb_adr_ogc_fid
  ON av_gb2av_work.t_geb_adr
  USING btree
  (ogc_fid);
  
CREATE INDEX idx_av_gb2av_work_t_geb_adr_gem_bfs
  ON av_gb2av_work.t_geb_adr
  USING btree
  (gem_bfs);

CREATE INDEX idx_av_gb2av_work_t_geb_adr_geometrie
  ON av_gb2av_work.t_geb_adr
  USING gist
  (geometrie);

CREATE INDEX idx_av_gb2av_work_t_geb_adr_lage
  ON av_gb2av_work.t_geb_adr
  USING gist
  (lage);
