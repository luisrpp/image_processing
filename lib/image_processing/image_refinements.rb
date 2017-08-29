# frozen_string_literal: true

module ImageProcessing
  # Image Refinements
  module ImageRefinements
    refine Vips::Image do
      # Converts the image to greyscale.
      #
      # @return [Vips::Image] greyscale image
      def to_greyscale
        if format == :uchar
          colourspace(:b_w)[0]
        else
          colourspace(:grey16)[0]
        end
      end

      # Get all non zero pixels of the image.
      #
      # @return [Array<Hash<Symbol, Object>>] non zero pixels
      def non_zero_pixels
        pixels = []
        to_a.each_with_index do |row, i|
          row.each_with_index do |value, j|
            pixels << { x: i, y: j, value: value } unless value.sum.zero?
          end
        end
        pixels
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
