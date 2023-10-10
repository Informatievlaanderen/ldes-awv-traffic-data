# Analysis
The Agentschap Wegen en Verkeer (AWV) measures [traffic data](./schema/miv-verkeersdata.xsd) every minute using dubble loops [mainly on highways in Flanders](./schema/miv-config.xsd). This [data](https://www.vlaanderen.be/datavindplaats/catalogus/meten-in-vlaanderen-minuutwaarden-verkeersmetingen) is publicly available.

* a **measurement point** (*meetpunt* in a [configuration](./data/20191205T092649Z.miv-config.xml) dataset) is an entity defining and describing a dubble loop for measuring traffic data
* an **observation** (*meetpunt* in a [traffic data](./data/20230502T100106Z.miv-verkeersdata.xml) dataset) is an entity containing measured and some calculated values, e.g. number of vehicles and average speed per vehicle category, aggregated per minute

## Requirements
The measurement points and observations need to be published as two separate linked data event streams (LDES'es).  In order to do so, we need to ingest measurement point information (state objects) and create measurement point versions (version objects). Likewise, we need to ingest observations and create version objects for these observations.

MUST, SHOULD and MAY keywords are used as defined by [rfc2119](https://www.rfc-editor.org/rfc/rfc2119).

* MUST identify measurement points as `https://www.wegenenverkeer.be/id/traffic-data/measurement-point/{unieke_id}` where `unieke_id` is a positive integer
* MUST identify observations as `https://www.wegenenverkeer.be/id/traffic-data/observation/{unieke_id}` where `unieke_id` is a positive integer
* MUST identify observations versions as `https://www.wegenenverkeer.be/id/traffic-data/observation/{unieke_id}#{tijd_waarneming}` where `unieke_id` is a positive integer and `{tijd_waarneming}` is an ISO8601 timestamp
* MUST use `https://wegenenverkeer.be/ns/traffic-data#` as the namespace prefix
* MUST map measurement point to a `:MeasurementPoint` where `:` is `https://wegenenverkeer.be/ns/traffic-data#`
* MUST map observation to `:Observation`  where `:` is `https://wegenenverkeer.be/ns/traffic-data#`

## Mapping Measurement Points
The measurement points are available [here](http://miv.opendata.belfla.be/miv/configuratie/xml) and follow this [schema](https://miv.opendata.belfla.be/miv-config.xsd), e.g.
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<mivconfig xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
           xsi:noNamespaceSchemaLocation="http://miv.opendata.belfla.be/miv-config.xsd" schemaVersion="1.0.0">
    <tijd_laatste_config_wijziging>2019-12-05T10:26:49+01:00</tijd_laatste_config_wijziging>
    <meetpunt unieke_id="3640">
        <beschrijvende_id>H291L10</beschrijvende_id>
        <volledige_naam>Parking Kruibeke</volledige_naam>
        <Ident_8>A0140002</Ident_8>
        <lve_nr>437</lve_nr>
        <Kmp_Rsys>94,695</Kmp_Rsys>
        <Rijstrook>R10</Rijstrook>
        <X_coord_EPSG_31370>144474,5297</X_coord_EPSG_31370>
        <Y_coord_EPSG_31370>208293,5324</Y_coord_EPSG_31370>
        <lengtegraad_EPSG_4326>4,289731136</lengtegraad_EPSG_4326>
        <breedtegraad_EPSG_4326>51,18460764</breedtegraad_EPSG_4326>
    </meetpunt>
    ...
</mivconfig>
```
We need to map the above model to a linked data model: 

```text
  @prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .
  @prefix dct:  <http://purl.org/dc/terms/> .
  @prefix locn: <http://www.w3.org/ns/locn#> .
  @prefix geo:  <http://www.opengis.net/ont/geosparql#> .
  @prefix sf:   <http://www.opengis.net/ont/sf#> .
  @prefix :     <https://wegenenverkeer.be/ns/traffic-data#> .

  <https://www.wegenenverkeer.be/id/traffic-data/measurement-point/{@unieke_id}> 
    a :MeasurementPoint ;
    :unieke_id "{@unieke_id}" ;
    :beschrijvende_id "{beschrijvende_id}" ;
    :volledige_naam "{volledige_naam}" ;
    :Ident_8 "{Ident_8}" ;
    :lve_nr "{lve_nr}"^^xsd:Integer ;
    :Kmp_Rsys "{Kmp_Rsys}" ;
    :Rijstrook "{Rijstrook}" ;
    :X_coord_EPSG_31370 "{X_coord_EPSG_31370}" ;
    :Y_coord_EPSG_31370 "{Y_coord_EPSG_31370}" ;
    :lengtegraad_EPSG_4326 "{lengtegraad_EPSG_4326}" ;
    :breedtegraad_EPSG_4326 "{breedtegraad_EPSG_4326}" ;
    locn:geometry [
        a sf:Point ;
        geo:asGML "<gml:Point srsName=\"http://www.opengis.net/def/crs/EPSG/0/31370\"><gml:coordinates>{X_coord_EPSG_31370},{Y_coord_EPSG_31370}</gml:coordinates><gml:Point>"^^geo:gmlLiteral ;
        geo:asWKT "<http://www.opengis.net/def/crs/OGC/1.3/CRS84>POINT({lengtegraad_EPSG_4326} {breedtegraad_EPSG_4326})"^^geo:wktLiteral ;
    ] ;
    dct:modified "{../tijd_laatste_config_wijziging}"^^xsd:dateTime .
```

## Mapping Observations
The observations are available [here](http://miv.opendata.belfla.be/miv/verkeersdata) and follow this [schema](https://miv.opendata.belfla.be/miv-verkeersdata.xsd), e.g.
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<miv xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://miv.opendata.belfla.be/miv-verkeersdata.xsd" schemaVersion="1.0.0">
    <tijd_publicatie>2023-05-02T12:01:06.144+02:00</tijd_publicatie>
    <tijd_laatste_config_wijziging>2019-12-05T10:26:49+01:00</tijd_laatste_config_wijziging>
    <meetpunt beschrijvende_id="H222L10" unieke_id="29">
        <lve_nr>55</lve_nr>
        <tijd_waarneming>2023-05-02T10:59:00+01:00</tijd_waarneming>
        <tijd_laatst_gewijzigd>2023-05-02T12:00:12+02:00</tijd_laatst_gewijzigd>
        <actueel_publicatie>0</actueel_publicatie>
        <beschikbaar>1</beschikbaar>
        <defect>0</defect>
        <geldig>0</geldig>
        <meetdata klasse_id="1">
            <verkeersintensiteit>0</verkeersintensiteit>
            <voertuigsnelheid_rekenkundig>0</voertuigsnelheid_rekenkundig>
            <voertuigsnelheid_harmonisch>252</voertuigsnelheid_harmonisch>
        </meetdata>
        <meetdata klasse_id="2">
            <verkeersintensiteit>0</verkeersintensiteit>
            <voertuigsnelheid_rekenkundig>0</voertuigsnelheid_rekenkundig>
            <voertuigsnelheid_harmonisch>252</voertuigsnelheid_harmonisch>
        </meetdata>
        <meetdata klasse_id="3">
            <verkeersintensiteit>0</verkeersintensiteit>
            <voertuigsnelheid_rekenkundig>0</voertuigsnelheid_rekenkundig>
            <voertuigsnelheid_harmonisch>252</voertuigsnelheid_harmonisch>
        </meetdata>
        <meetdata klasse_id="4">
            <verkeersintensiteit>0</verkeersintensiteit>
            <voertuigsnelheid_rekenkundig>0</voertuigsnelheid_rekenkundig>
            <voertuigsnelheid_harmonisch>252</voertuigsnelheid_harmonisch>
        </meetdata>
        <meetdata klasse_id="5">
            <verkeersintensiteit>0</verkeersintensiteit>
            <voertuigsnelheid_rekenkundig>0</voertuigsnelheid_rekenkundig>
            <voertuigsnelheid_harmonisch>252</voertuigsnelheid_harmonisch>
        </meetdata>
        <rekendata>
            <bezettingsgraad>0</bezettingsgraad>
            <beschikbaarheidsgraad>100</beschikbaarheidsgraad>
            <onrustigheid>0</onrustigheid>
        </rekendata>
    </meetpunt>
    ...
</miv>
```

We need to map the above model to a linked data model: 

```text
  @prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .
  @prefix dct:  <http://purl.org/dc/terms/> .
  @prefix :     <https://wegenenverkeer.be/ns/traffic-data#> .

  <http://www.wegenenverkeer.be/id/traffic-data/observation/{@unieke_id}> 
    a :Observation ;
    :unieke_id "{@unieke_id}" ;
    :beschrijvende_id "{beschrijvende_id}" ;
    :lve_nr "{lve_nr}"^^xsd:Integer ;
    :tijd_waarneming "{tijd_waarneming}"^^xsd:dateTime ;
    :tijd_laatst_gewijzigd "{tijd_laatst_gewijzigd}"^^xsd:dateTime ;
    :actueel_publicatie "{actueel_publicatie}"^^xsd:int ;
    :beschikbaar "{beschikbaar}"^^xsd:int ;
    :defect "{defect}"^^xsd:int ;
    :geldig "{geldig}"^^xsd:int ;
# foreach meetdata
    :meetdata [ 
        a :Measurement
        :klasse_id "{klasse_id}"^^xsd:Integer ; 
        :verkeersintensiteit "{verkeersintensiteit}"^^xsd:Integer ; 
        :voertuigsnelheid_rekenkundig "{voertuigsnelheid_rekenkundig}"^^xsd:Integer ; 
        :voertuigsnelheid_harmonisch "{voertuigsnelheid_harmonisch}"^^xsd:Integer ; 
    ] ;
# end foreach meetdata
    :rekendata [ 
        a :Calculation
        :bezettingsgraad "{bezettingsgraad}"^^xsd:Integer ; 
        :beschikbaarheidsgraad "{beschikbaarheidsgraad}"^^xsd:Integer ; 
        :onrustigheid "{onrustigheid}"^^xsd:Integer ; 
    ] ;
    :tijd_publicatie "{../tijd_publicatie}"^^xsd:dateTime ;
    :tijd_laatste_config_wijziging "{../tijd_laatste_config_wijziging}"^^xsd:dateTime .
    dcterms:created "{tijd_waarneming}"^^xsd:dateTime .
```
