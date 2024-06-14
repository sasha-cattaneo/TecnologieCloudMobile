###### TEDx-Load-Aggregate-Model
######

import sys
import json
import pyspark
from pyspark.sql.functions import col, collect_list, array_join, struct

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job



##### FROM FILES
tedx_dataset_path = "s3://tedx-2024-data-catta/final_list.csv"

###### READ PARAMETERS
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

##### START JOB CONTEXT AND JOB
sc = SparkContext()


glueContext = GlueContext(sc)
spark = glueContext.spark_session


    
job = Job(glueContext)
job.init(args['JOB_NAME'], args)


#### READ INPUT FILES TO CREATE AN INPUT DATASET
tedx_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(tedx_dataset_path)
    
tedx_dataset.printSchema()


#### FILTER ITEMS WITH NULL POSTING KEY
count_items = tedx_dataset.count()
count_items_null = tedx_dataset.filter("id is not null").count()

print(f"Number of items from RAW DATA {count_items}")
print(f"Number of items from RAW DATA with NOT NULL KEY {count_items_null}")


## READ THE DETAILS
details_dataset_path = "s3://tedx-2024-data-catta/details.csv"
details_dataset = spark.read \
    .option("header","true") \
    .option("quote", "\"") \
    .option("escape", "\"") \
    .csv(details_dataset_path)

details_dataset = details_dataset.select(col("id").alias("id_ref"),
                                         col("interalId").alias("internalId"),
                                         col("description"),
                                         col("duration"),
                                         col("publishedAt"))

# AND JOIN WITH THE MAIN TABLE
tedx_dataset_main = tedx_dataset.join(details_dataset, tedx_dataset.id == details_dataset.id_ref, "left") \
    .drop("id_ref")

tedx_dataset_main.printSchema()


## READ TAGS DATASET
tags_dataset_path = "s3://tedx-2024-data-catta/tags.csv"
tags_dataset = spark.read.option("header","true").csv(tags_dataset_path)



# CREATE THE AGGREGATE MODEL, ADD TAGS TO TEDX_DATASET
tags_dataset_agg = tags_dataset.groupBy(col("id").alias("id_ref")).agg(collect_list("tag").alias("tags"))
tags_dataset_agg.printSchema()
tedx_dataset_agg = tedx_dataset_main.join(tags_dataset_agg, tedx_dataset.id == tags_dataset_agg.id_ref, "left") \
    .drop("id_ref") \
    .select(col("id").alias("_id"), col("*")) \
    .drop("id") \

tedx_dataset_agg.printSchema()

## READ IMAGES DATASET
images_dataset_path = "s3://tedx-2024-data-catta/images.csv"
images_dataset = spark.read.option("header","true").csv(images_dataset_path)

images_dataset.printSchema()

# CREATE THE AGGREGATE MODEL, ADD IMAGES TO TEDX_DATASET
images_dataset_agg = images_dataset.select(col("id"),
                                           col("url").alias("url_image"))
images_dataset_agg.printSchema()
tedx_dataset_agg = tedx_dataset_agg.join(images_dataset_agg, tedx_dataset_agg._id == images_dataset_agg.id, "left") \
    .drop("id") \

tedx_dataset_agg.printSchema()


## READ RELATED DATASET
related_dataset_path = "s3://tedx-2024-data-catta/related_videos.csv"
related_dataset = spark.read.option("header", "true").csv(related_dataset_path)

related_dataset.printSchema()
"""
tedx_dataset_agg = tedx_dataset_agg.select( col("id").alias("_id"),
                                            col("internalId").alias("internalRelatedId"),
                                            col("speakers"),
                                            col("url"),
                                            col("description"),
                                            col("publishedAt"))
"""
related_dataset_agg = related_dataset.select(   col("id"),
                                                col("related_id")
    )

related_dataset_agg = related_dataset_agg.join(tedx_dataset_agg, related_dataset_agg.related_id == tedx_dataset_agg.internalId, "left")

# CREATE THE AGGREGATE MODEL, ADD RELATED_VIDS TO TEDX_DATASET
related_dataset_agg = related_dataset_agg.groupBy(col("id")) \
    .agg(collect_list(struct("_id",
                            "slug",
                            "speakers",
                            "title",
                            "url",
                            "description",
                            "duration",
                            "publishedAt",
                            "tags",
                            "url_image"
                            ).alias("related_video")).alias("related_videos"))

related_dataset_agg.printSchema()

tedx_dataset_agg = tedx_dataset_agg.join(related_dataset_agg, tedx_dataset_agg._id == related_dataset_agg.id, "left") \
    .drop("id") \
    .drop("internalId") \
    
tedx_dataset_agg.printSchema()


write_mongo_options = {
    "connectionName": "TEDX2024",
    "database": "unibg_tedx_2024",
    "collection": "tedx_data",
    "ssl": "true",
    "ssl.domain_match": "false"}
from awsglue.dynamicframe import DynamicFrame
tedx_dataset_dynamic_frame = DynamicFrame.fromDF(tedx_dataset_agg, glueContext, "nested")

glueContext.write_dynamic_frame.from_options(tedx_dataset_dynamic_frame, connection_type="mongodb", connection_options=write_mongo_options)