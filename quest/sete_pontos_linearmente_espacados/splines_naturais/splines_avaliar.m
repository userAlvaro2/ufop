## Copyright (C) 2023 Diego Sanches
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{sz}, @var{Info} =} splines_avaliar (@var{n}, @var{x}, @var{y}, @var{m}, @var{z}, @var{ts})
## entradas:
## numero de pontos, vetor de abscissas em ordem crescente, vetor de ordenadas,
## numero de pontos a interpolar, valores a interpolar e tipo de splines_avaliar
## saidas
## valores interpolados e informacao sobre erro, sendo Info = 0: sem erro, Info = -1:
## numero de pontos de n<3 ou n <4 (depende do spline), Info = -2: abscissas nao estao
## em ordem crescente e Info > 0: numero de tentativas de extrapolacao.
## @seealso{}
## @end deftypefn

## Author: Diego Sanches
## Created: 2023-06-27

function [sz, Info] = splines_avaliar (n, x, y, m, z, ts)
  if ts == 0
    [s2, Info] = splines_naturais(n,x,y);
  else
    [s2, Info] = splines_extrapolados(n,x,y);
  endif
  if Info < 0
    return;
  endif
  Info = 0;
  for j = 1 : m
    if (z(j) >= x(1)) && (z(j) <=  x(n))
      # Pesquisa binarios para localizar o intervalo
      inf = 1;
      sup = n;
      while 1
        if (sup - inf) <= 1
          break;
        endif
        ind  = round((inf+sup)/2);
        if x(ind) > z(j)
          sup = ind;
        else
          inf = ind;
        endif
      endwhile
      # Avaliacao do spline pelo metodo de Horner
      h = x(sup) - x(inf);
      a = (s2(sup)-s2(inf))/(6*h);
      b = s2(inf)/2;
      c = (y(sup)-y(inf))/h-(s2(sup)+2*s2(inf))*h/6;
      d = y(inf);
      h = z(j)-x(inf);
      sz(j)=((a*h+b)*h+c)*h+d;
    else
      sz(j) = 0;
      Info = Info + 1;
    endif
  endfor
endfunction
