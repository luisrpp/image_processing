# frozen_string_literal: true

module Vips
  # Image class (new methods)
  class Image
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

    # Draw lines in the image.
    #
    # @param ink [Float|Array<Float>] pixel value
    # @param lines [Array<Hash<Symbol, Float>>] list of lines with theta and rho values
    #
    # @return [Vips::Image] image with the lines
    def draw_lines(ink, lines)
      image = self

      lines.each do |line|
        a = Math.cos(line[:theta])
        b = Math.sin(line[:theta])
        x0 = b * line[:rho]
        y0 = a * line[:rho]
        x1 = (x0 + size[0] * size[1] * a).round
        y1 = (y0 + size[0] * size[1] * -b).round
        x2 = (x0 - size[0] * size[1] * a).round
        y2 = (y0 - size[0] * size[1] * -b).round
        image = image.draw_line(ink, x1, y1, x2, y2)
      end

      image
    end
  end
end
