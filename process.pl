#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

# Crear un nuevo objeto CGI
my $query = CGI->new();

# Imprimir encabezados HTML
print $query->header(-type => 'text/html', -charset => 'utf-8', -style=> [{ src = /estilos.css}]);
print $query->start_html( -title => 'Información de la Universidad' );
print $query->h1('Resultados de la Búsqueda');

# Obtener el código de la universidad del formulario
my $codigo_universidad = $query->param('codigo_universidad');
chomp($codigo_universidad);

# Abrir el archivo CSV
open(my $fh, '<', 'Programas_de_Universidades.csv') or die("Error al abrir el archivo: $!");

# Variable para almacenar si se encontró la universidad
my $encontrado = 0;

# Leer el archivo línea por línea
while (my $line = <$fh>) {
    chomp($line);

    # Saltar líneas sin datos útiles
    next if $line =~ /^\s*\|+\s*$/;

    # Separar los campos por "|"
    my @campos = split /\|/, $line;

    # Si el código de la universidad coincide
    if ($campos[0] eq $codigo_universidad) {
        print "<p><strong>Nombre Universidad:</strong> $campos[1]</p>";
        print "<p><strong>Periodo Licenciamiento:</strong> $campos[2]</p>";
        print "<p><strong>Departamento Local:</strong> $campos[3]</p>";
        print "<p><strong>Denominación Programa:</strong> $campos[4]</p>";
        $encontrado = 1;
        last;
    }
}

# Cerrar el archivo
close($fh);

# Si no se encontró la universidad
if (!$encontrado) {
    print "<p>No se encontró la universidad con el código $codigo_universidad.</p>";
}

# Finalizar HTML
print $query->end_html;
