# Selects at random a GPX route, and executes it from the beginning to the end.
module Behaviors
  class RandomMover < Madmass::AgentFarm::Agent::Behavior

    def initialize()

      #Madmass.logger.info "Random Mover: creating with  agent_id #{@agent.oid}"

      @current_route = nil
      @position_in_route = 0
    end

    #Select a Random route
    def choose!
      #Madmass.logger.debug("Choosing new plan")
      routes = CloudTm::Route.all
      if routes.any?
        random_route_pos = rand(routes.size - 1)
        #Madmass.logger.debug("#{random_route_pos}-th plan out of #{routes.size - 1} plans  chosen")
        i=0
        routes.each do |r| #routes cannot be converted to array because of direct mapper
          if (i==random_route_pos)
            @current_route = extract_route(r)
            #Madmass.logger.debug("#{random_route_pos}-th route is #{@current_route.inspect}")
            #@current_route.each_index{|ind| Madmass.logger.info "route idx #{ind}"}
            @position_in_route = 0
            raise MadMass::Errors::CatastrophicError.new("Positions in route missing") if (@current_route.include?(nil))
            break
          end
          i+= 1;
        end
      else
        raise Madmass::Errors::CatastrophicError.new "No GPX routes available!"
      end
    end

    def defined?
      # Madmass.logger.debug("Plan finished when current position is #{@position_in_route}") unless @current_route
      return (@current_route != nil)
    end

    #Select the next action that moves from
    def next_action
      action = move_params(@current_route[@position_in_route])
      #puts "position #{@position_in_route+1}/#{@current_route.size}"
      if (@position_in_route < @current_route.size - 1)
        @position_in_route += 1
      else
        @current_route = nil
      end
      return action
    end

    def last_wish
      destroy_agent_params
    end


    private


    def extract_route dml_route
      route = []
      #FIXME: interpolate routes
      dml_route.getPositions.each do |pos|
        route[pos.progressive] = {
          :latitude => pos.latitude.to_s,
          :longitude => pos.longitude.to_s
        }
      end
      return route;
    end

    def move_params opts
      return {
        :cmd => "madmass::action::remote",
        :data => {
          :cmd => 'move',
          :data => {
            :type => "Mover",
            :body => "Mover with position\n <#{opts[:latitude].to_s}, #{opts[:longitude].to_s}>"
          },
          :sync => true,
          :user => {:id => @agent.getExternalId}
        }.merge(opts)
      }
    end

    def destroy_agent_params(opts = {})
      return {
        :cmd => "madmass::action::remote",
        :data => {
          :cmd => 'destroy_agent',
          :sync => true,
          :user => {:id => @agent.getExternalId}
        }.merge(opts)
      }
    end

  end

end

