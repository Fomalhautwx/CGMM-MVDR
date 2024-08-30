function varargout = colon(test, varargin)
  [varargout{1 : nargout}] = varargin{2 - test}();