Name        : libzbxpgsql
Vendor      : cavaliercoder
Version     : 1.1.0
Release     : 1
Summary     : PostgreSQL monitoring module for Zabbix

Group       : Applications/Internet
License     : GNU GPLv2
URL         : https://github.com/cavaliercoder/libzbxpgsql

# Zabbix sources (Customized)
Source0     : %{name}-%{version}.tar.gz

Buildroot   : %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

# package dependencies
%if "%{_zabbix_version}" == "2"
Requires    : zabbix-agent >= 2.2.0, zabbix-agent < 3.0.0
%define moddir %{_libdir}
%else
Requires    : zabbix-agent >= 3.0.0
%define moddir %{_libdir}/zabbix
%endif

# minimum libpq version based on latest patch of RHEL 5
Requires    : postgresql-libs >= 8.1.23

%description
libzbxpgsql is a comprehensive PostgreSQL discovery and monitoring module for the Zabbix monitoring agent written in C.

%prep
# Extract and configure sources into $RPM_BUILD_ROOT
%setup0 -q -n %{name}-%{version}

err=0

if ! type -p pg_config && [[ -z "$PG_CONFIG" ]] ; then
    echo >&2 "pg_config must be in your path or set in $PG_CONFIG"
    err=1
fi

if ! test -d /usr/src/zabbix/include ; then
    if [[ -z "$ZABBIX_SOURCE" ]] || ! test -d "$ZABBIX_SOURCE" ;then 
      echo >&2 "set ZABBIX_SOURCE to the location where we can find zabbix .h files (eg /usr/src/zabbix)"
      err=1
    fi
fi

[[ $err = 0 ]]  || exit $err

test -f configure  || ./autogen.sh

# fix up some lib64 issues
sed -i.orig -e 's|_LIBDIR=/usr/lib|_LIBDIR=%{_libdir}|g' configure

%build
# Configure and compile sources into $RPM_BUILD_ROOT
%configure --enable-dependency-tracking --with-zabbix="$ZABBIX_SOURCE"
make %{?_smp_mflags}

%install
# Install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install

# Move lib into .../modules/
install -dm 755 $RPM_BUILD_ROOT%{moddir}
install -dm 755 $RPM_BUILD_ROOT%{moddir}/modules
mv $RPM_BUILD_ROOT%{_libdir}/%{name}.so $RPM_BUILD_ROOT%{moddir}/modules/%{name}.so

# Create agent config file
install -dm 755 $RPM_BUILD_ROOT%{_sysconfdir}/zabbix/zabbix_agentd.d
echo "LoadModule=libzbxpgsql.so" > $RPM_BUILD_ROOT%{_sysconfdir}/zabbix/zabbix_agentd.d/%{name}.conf
install -dm 755 $RPM_BUILD_ROOT%{_sysconfdir}/%{name}.d
install -m 644 query.conf $RPM_BUILD_ROOT%{_sysconfdir}/%{name}.d/

%clean
# Clean out the build root
rm -rf $RPM_BUILD_ROOT

%files
%{moddir}/modules/libzbxpgsql.so
%{_sysconfdir}/zabbix/zabbix_agentd.d/%{name}.conf
%{_sysconfdir}/%{name}.d/query.conf

%changelog
* Sat Aug 20 2016 Ryan Armstrong <ryan@cavaliercoder.com> 1.1.0-1
- Added configuration file for long custom queries - Rob Brucks

* Sun Jun 26 2016 Ryan Armstrong <ryan@cavaliercoder.com> 1.0.0-1
- Added support for Zabbix v3
- Added multi-database support for discovering schema, tables and indexes
- Added error messages to failed requests
- Monitoring connections are no longer counted when monitoring backend
  connection counts
- Added `pg.db.xid_age` to monitor the allocation of Transaction IDs
- Added `pg.table.*_perc` keys to measure cache hit ratios for tables
- Added `pg.checkpoint_avg_interval` to return average interval between
  checkpoint operations in seconds
- Added `pg.checkpoint_time_perc` to measure the percentage of time spent
  in checkpoint operations since last reset
- Added `pg.stats_reset_interval` to return seconds since background writer
  stats were reset
- Added `pg.table.n_mod_since_analyze` to return the estimated number of rows
  that have been modified since the last table analyze
- Added support for `pg.queries.longest` in PostgreSQL versions prior to 9.2
- Added `pg.prepared_xacts_count` to return the number of transactions currently
  prepared for two phase commit
- Added `pg.prepared_xacts_ratio` to return the number of transactions currently
  prepared for two phase commit as a ratio of the maximum permitted prepared
  transaction count
- Added `pg.prepared_xacts_age` to return the age of the oldest transaction
  currently prepared for two phase commit
- Added `pg.backends.free` to return the number of available backend connections
- Added `pg.backends.ratio` to return the ratio of used available backend
  connections
- Added `--with-postgresql` switch to source configuration script
- Added `--with-zabbix` switch to source configuration script
- Fixed misreporting in `pg.queries.longest` when no queries were in progress
- Fixed build dependencies on Debian (thanks darkweaver87)
- Moved build scripts to a new repository (cavaliercoder/libzbxpgsql-build)

* Mon Sep 14 2015 Ryan Armstrong <ryan@cavaliercoder.com> 0.2.1-1
- Fixed connection leak in pg_version()
- Fixed query error in pg.index.rows key
- Removed noisy logging in pg.query.* keys

* Sun Aug 16 2015 Ryan Armstrong <ryan@cavaliercoder.com> 0.2.0-1
- Improved connections parameters on all item keys
- Add custom discovery rules via `pg.query.discovery`
- Fixed compatability issues with < v9.2
- Added support for OpenSUSE v13.2
- Added SQL injection prevention
- Added `pg.uptime` and `pg.starttime` keys
- Added `pg.modver` key to monitor the installed `libzbxpgsql` version
- Reduced required privileges for all keys to just `LOGIN`
- Fixed integer overflow issues on large objects
- Improved automated testing and packaging using Docker and `zabbix_agent_bench`

* Tue Mar 17 2015 Ryan Armstrong <ryan@cavaliercoder.com> 0.1.3-1
- Added configuration directive discovery

* Fri Feb 20 2015 Ryan Armstrong <ryan@cavaliercoder.com> 0.1.2-1
- Fixed module installation path
- Added git reference to library version info
- Added project and RPM build to Travis CI
- Improved detection of PostgreSQL OIDs and IP addresses in parameter values

* Mon Feb 16 2015 Ryan Armstrong <ryan@cavaliercoder.com> 0.1.1-1
- Added `pg.queries.longest` key
- Added `pg.setting` key
- Added `pg.query.*` keys
- Improved documentation

* Sat Feb 7 2015 Ryan Armstrong <ryan@cavaliercoder.com> 0.1.0-1
- Initial release
