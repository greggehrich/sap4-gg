require 'csv'
class FilemakerMsaFipsZipCodeImport

  def self.run!
    fr = "#{Rails.root.to_s}/db/data_imports/"
    zipcodes_csv = "#{fr}/ZIP_CODES.xlsx\ -\ Sheet1.csv"
    fips_csv = "#{fr}/FIPS.xlsx\ -\ Sheet1.csv"
    msa_infos_csv = "#{fr}/MSA_INFOS.xlsx\ -\ Sheet1.csv"

    # MSA_INFOS
    puts "\n\n\n\n\nimporting msa_infos_csv..."
    CSV.foreach(msa_infos_csv, {headers: true}) do |row|
      find_or_create_msa_info(row)
    end

    # FIPS
    puts "\n\n\n\n\nimporting fips_csv..."
    CSV.foreach(fips_csv, {headers: true}) do |row|
      find_or_create_fip(row)
    end

    # ZIP_CODES
    puts "\n\n\n\n\nimporting zip_codes_csv..."
    CSV.foreach(zipcodes_csv, {headers: true}) do |row|
      find_or_create_zip_code(row)
    end

  end


  private

  def self.find_or_create_msa_info(row)
    name = row[0]
    description = row[1]
    MsaInfo.where(name: name, description: description).first_or_create!
  end

  def self.find_or_create_fip(row)
    aux_data = {}
    aux_data[:cbsa_code] = row[0]
    msa_name = row[1]
    aux_data[:div_code] = row[2]
    aux_data[:metropolitan_division_name] = row[3]
    external_fip_id = row[4]
    aux_data[:state] = row[5]
    aux_data[:component_name] = row[6]
    aux_data[:component_type] = row[7]
    msa_info = MsaInfo.where(name: msa_name).first
    if msa_info && external_fip_id.present?
      my_atts = {msa_info_id: msa_info.id, external_fip_id: external_fip_id.to_i}
      f = Fip.where(my_atts).first
      f = f ? f : Fip.create!(my_atts.merge(aux_data: aux_data))
    end
  end

  def self.find_or_create_zip_code(row)
    aux_data = {}
    legacy_zip_code_id = row[0]
    zip_code= row[1]
    aux_data[:city] = row[2]
    aux_data[:state] = row[3]
    aux_data[:county] = row[4]
    aux_data[:city_type] = row[5]
    aux_data[:city_alias_abbreviation] = row[6]
    aux_data[:city_alias_name] = row[7]
    aux_data[:lat] = row[8]
    aux_data[:lng] = row[9]
    aux_data[:county_fips] = row[10]
    aux_data[:preferred_last_line_key] = row[11]
    aux_data[:classification_code] = row[12]
    aux_data[:state_fips] = row[13]
    aux_data[:city_state_key] = row[14]
    aux_data[:city_alias_code] = row[15]
    combined_fips_code = row[16]
    fip = Fip.where(external_fip_id: combined_fips_code).first
    if fip
      zc = ZipCode.where(postal_code: zip_code, fip_id: fip.id).first
      zc = zc ? zc : ZipCode.create!(postal_code: zip_code, fip_id: fip.id, aux_data: aux_data)
    end
  end

end
