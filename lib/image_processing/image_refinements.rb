# frozen_string_literal: true

module ImageProcessing
  # Image Refinements
  module ImageRefinements
    refine Vips::Image do
      def to_grayscale
        if format == :uchar
          colourspace(:b_w)[0]
        else
          colourspace(:grey16)[0]
        end
      end
    end
  end
end
