class Definition < ApplicationRecord
  enum :context, { legal: 0, financial: 1, construction: 2, civic: 3, general: 4 }, prefix: true
end
