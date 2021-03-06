###############################################################################
###############################################################################
#
# This file is part of GeoGraph Agent Farm.
#
# Copyright (c) 2012 Algorithmica Srl
#
# GeoGraph Agent Farm is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GeoGraph Agent Farm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with GeoGraph Agent Farm.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact us via email at info@algorithmica.it or at
#
# Algorithmica Srl
# Vicolo di Sant'Agata 16
# 00153 Rome, Italy
#
###############################################################################
###############################################################################

# This initializer identifies the agent types.

sources = Dir.glob(File.join(Rails.root, 'lib', 'cloud_tm', 'models', '*_agent.rb'))
klasses = []
sources.each do |source|
  klass = source.sub(/\.rb$/, '').classify.demodulize
  klasses << klass
  #FIXME: safer but does not work:
  #klasses << klass if klass.constantize < Agent
end
AGENT_TYPES = klasses.sort
AGENT_TYPES_FOR_SELECT = AGENT_TYPES.map{|at| [at.sub(/Agent$/, '').downcase, at]}