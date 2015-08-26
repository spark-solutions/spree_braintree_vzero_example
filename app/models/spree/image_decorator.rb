Spree::Image.class_eval do

  has_attached_file :attachment,
                    styles: {
                      mini:     '48x48>',
                      small:    '100x100>',
                      product:  '240x240>',
                      large:    '600x600>'
                    },
                    convert_options: {
                      all: '-strip -auto-orient -colorspace sRGB'
                    },
                    default_style:  'product'

end
