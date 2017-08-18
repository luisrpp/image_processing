# frozen_string_literal: true

module ImageProcessing
  # Image Refinements
  module ImageRefinements
    refine Vips::Image do
      # Converts the image to greyscale.
      #
      # @return [Vips::Image] grayscale image
      def to_greyscale
        if format == :uchar
          colourspace(:b_w)[0]
        else
          colourspace(:grey16)[0]
        end
      end

      # Threshold operation.
      #
      # @param thresh [Integer] threshold value
      # @param type [Symbol] threshold type
      #
      # @return [Vips::Image] threshold result
      # @raise [ImageProcessing::ImageProcessingError] for invalid types
      def threshold(thresh, type = :thresh_binary)
        case type
        when :thresh_binary
          self > thresh
        else
          raise ImageProcessing::ImageProcessingError, 'Invalid threshold type'
        end
      end
    end
  end
end
