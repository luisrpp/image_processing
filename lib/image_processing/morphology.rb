# frozen_string_literal: true

module ImageProcessing
  # Morphology class
  class Morphology
    class << self
      # Dilation on grayscale images, implemented with maximum filter.
      #
      # @param image [Vips::Image] grayscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] dilation result
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def dilate(image, size_w = 3, size_h = size_w)
        validate_image(image)
        image.rank(size_w, size_h, size_w * size_h - 1)
      end

      # Erode on grayscale images, implemented with minimum filter.
      #
      # @param image [Vips::Image] grayscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] erosion result
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def erode(image, size_w = 3, size_h = size_w)
        validate_image(image)
        image.rank(size_w, size_h, 0)
      end

      # Morphological gradient.
      #
      # @param image [Vips::Image] grayscale image
      # @param size_w [Integer] the width of the window
      # @param size_h [Integer] the height of the window
      #
      # @return [Vips::Image] the morphological gradient
      # @raise [ImageProcessing::ImageProcessingError] in case of invalid images
      def gradient(image, size_w = 3, size_h = size_w)
        dilate(image, size_w, size_h)
          .subtract(erode(image, size_w, size_h))
      end

      private

      def validate_image(image)
        raise ImageProcessing::ImageProcessingError, 'Use a grayscale image!' unless image.bands == 1
      end
    end
  end
end
