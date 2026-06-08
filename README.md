# Windows Server ja Linux Serverite Haldus

Käesolev repository sisaldab kutseeksami praktilise töö käigus loodud skripte, konfiguratsioonifaile ja automatiseerimise lahendusi.

## Sisu

### PowerShell skriptid

| Fail | Kirjeldus |
|--------|------------|
| loo_kasutajad.ps1 | Active Directory kasutajate automaatne loomine CSV failist |
| Loo_kaustad.ps1 | Kodukaustade ja jagatud kaustade loomine ning õiguste määramine |

### CSV failid

| Fail | Kirjeldus |
|--------|------------|
| kasutajad.csv | Kasutajate andmed Active Directory kontode loomiseks |
| testkasutajad.csv | Testandmed PowerShell skriptide kontrollimiseks |

### Ansible

| Fail | Kirjeldus |
|--------|------------|
| inventory.ini | Hallatavate Linux serverite inventar |
| secure_linux.yml | Linux serverite turvaseadistuste automatiseerimine Ansible abil |

Playbook teostab järgmised tegevused:

- kasutaja **hkhk** loomine
- SSH avaliku võtme kopeerimine kasutajale
- sudo/wheel grupi liikmelisuse määramine
- paroolita sudo õiguste seadistamine
- SSH parooliga autentimise keelamine

### Docker

| Fail | Kirjeldus |
|--------|------------|
| docker-compose.yml | Vaultwardeni konteineri käivitamine Docker Compose abil |

### Apache

| Fail | Kirjeldus |
|--------|------------|
| vaultwarden.conf | Apache Reverse Proxy konfiguratsioon Vaultwardeni teenusele |
| wordpress-ssl.conf | Apache Reverse Proxy konfiguratsioon Vasemba veebilehele |

## Projekti eesmärk

Projekti käigus seadistati:

- Windows Server domeenikeskkond
- Active Directory kasutajad ja grupid
- jagatud kaustad ning õigused
- DNS ja DHCP teenused
- Linux serverite turvamine Ansible abil
- WordPress veebikeskkond
- SSL sertifikaadid
- Vaultwarden paroolihaldur Dockeri konteineris
- Apache Reverse Proxy lahendus
