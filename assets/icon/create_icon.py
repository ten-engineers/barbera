#!/usr/bin/env python3
"""
Simple script to create app icon for Barbera
Creates a 1024x1024 PNG icon with a book/flashcard design
"""
from PIL import Image, ImageDraw, ImageFont
import os

def create_app_icon():
    # Create a 1024x1024 image
    size = 1024
    img = Image.new('RGB', (size, size), color='#2196F3')  # Blue background
    draw = ImageDraw.Draw(img)
    
    # Draw a book/flashcard shape
    # Main card/book shape
    margin = 150
    card_width = size - 2 * margin
    card_height = size - 2 * margin
    
    # Draw rounded rectangle for card
    draw.rounded_rectangle(
        [(margin, margin), (size - margin, size - margin)],
        radius=80,
        fill='#FFFFFF',
        outline='#1976D2',
        width=20
    )
    
    # Draw letter "B" in the center
    try:
        # Try to use a system font
        font_size = 400
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
        except:
            try:
                font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", font_size)
            except:
                font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()
    
    # Get text bounding box
    bbox = draw.textbbox((0, 0), "B", font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # Center the text
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - 50
    
    draw.text((x, y), "B", fill='#2196F3', font=font)
    
    # Save the icon
    output_path = 'app_icon.png'
    img.save(output_path, 'PNG')
    print(f"Created {output_path}")
    
    # Also create foreground for adaptive icon (transparent background)
    fg_img = Image.new('RGBA', (size, size), color=(0, 0, 0, 0))
    fg_draw = ImageDraw.Draw(fg_img)
    
    # Draw the same design but with transparent background
    fg_draw.rounded_rectangle(
        [(margin, margin), (size - margin, size - margin)],
        radius=80,
        fill='#FFFFFF',
        outline='#1976D2',
        width=20
    )
    
    fg_bbox = fg_draw.textbbox((0, 0), "B", font=font)
    fg_text_width = fg_bbox[2] - fg_bbox[0]
    fg_text_height = fg_bbox[3] - fg_bbox[1]
    fg_x = (size - fg_text_width) // 2
    fg_y = (size - fg_text_height) // 2 - 50
    
    fg_draw.text((fg_x, fg_y), "B", fill='#2196F3', font=font)
    
    fg_output_path = 'app_icon_foreground.png'
    fg_img.save(fg_output_path, 'PNG')
    print(f"Created {fg_output_path}")

if __name__ == '__main__':
    create_app_icon()

