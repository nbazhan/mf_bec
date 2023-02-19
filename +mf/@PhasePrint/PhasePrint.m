classdef PhasePrint
   properties
      model;
   end
   methods
      function obj = PhasePrint(params)
          if nargin == 1
              if isfield(params, 'model')
                  obj.model = params.model;
              end
          end
      end
   end
end